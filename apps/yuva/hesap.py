"""Yuva Hesap: hesap makinesi.

- Guvenli hesaplama: eval yok, ifade ast ile cozulur; Decimal ile 0,1+0,2 = 0,3
- Yazarken canli sonuc onizlemesi, bilimsel mod, kalici gecmis
- Klavye: rakamlar, + - * / ^ % ( ) , .  Enter: hesapla  Backspace: sil  Esc: temizle
  Ctrl+C: sonucu kopyala  Ctrl+H: gecmis  Ctrl+B: bilimsel mod
- Turkce sayi bicimi: 1.234,5 (girdi icin hem , hem . ondalik kabul edilir)
"""

import ast
import json
import math
import os
import re
import sys
from decimal import Decimal, DivisionByZero, InvalidOperation, getcontext

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Adw, Gdk, Gio, GLib, Gtk  # noqa: E402

from . import theme  # noqa: E402

APP_ID = "tr.yuva.Hesap"
HISTORY_FILE = os.path.expanduser("~/.local/share/yuva/hesap-gecmis.json")
HISTORY_MAX = 100

getcontext().prec = 34


# ───────────────────────── Hesaplama motoru ─────────────────────────

class CalcError(Exception):
    pass


def _d(x):
    """float -> Decimal (kisa temsil, 0.1 -> Decimal('0.1'))."""
    if isinstance(x, Decimal):
        return x
    if isinstance(x, float) and (math.isinf(x) or math.isnan(x)):
        raise CalcError("Tanımsız")
    return Decimal(repr(x)) if isinstance(x, float) else Decimal(x)


def _clean(x):
    """Trigonometrideki 1e-17 gibi kalintilari sifirla."""
    return Decimal(0) if abs(x) < Decimal("1e-15") else x


def _sqrt(x):
    if x < 0:
        raise CalcError("Negatif sayının karekökü yok")
    return x.sqrt()


def _log(x, fn):
    if x <= 0:
        raise CalcError("Logaritma için sayı pozitif olmalı")
    return _d(fn(float(x)))


FUNCS = {
    "sqrt": _sqrt,
    "sin": lambda x: _clean(_d(math.sin(math.radians(float(x))))),
    "cos": lambda x: _clean(_d(math.cos(math.radians(float(x))))),
    "tan": lambda x: _tan(x),
    "ln": lambda x: _log(x, math.log),
    "log": lambda x: _log(x, math.log10),
    "abs": abs,
}

CONSTS = {"pi": _d(math.pi), "e": _d(math.e)}


def _tan(x):
    if float(x) % 180 == 90:
        raise CalcError("tan(90°) tanımsız")
    return _clean(_d(math.tan(math.radians(float(x)))))


def to_python(expr):
    """Ekrandaki ifadeyi (× ÷ − ^ √ π , %) Python ifadesine cevirir."""
    s = expr
    for a, b in (("×", "*"), ("÷", "/"), ("−", "-"), ("^", "**"), ("π", "(pi)"), (",", "."), ("√", "sqrt")):
        s = s.replace(a, b)
    s = s.replace("%", "/100")
    # Ortulu carpma: 2π, 2(3), )(, 3sin(30)
    # ("e" sabiti harf olmayan komsularla ayirt edilir; \b rakam-harf arasinda calismaz)
    E = r"(?<![a-z])e(?![a-z])"
    for _ in range(2):  # ust uste binen eslesmeler icin (2eπ)
        s = re.sub(rf"(\d|\)|pi|{E})\s*(\(|pi|{E}|sqrt|sin|cos|tan|ln|log|abs)", r"\1*\2", s)
    # Kapanmamis parantezleri tamamla (onizleme ve "=" icin)
    s += ")" * max(0, s.count("(") - s.count(")"))
    return s


_BINOPS = (ast.Add, ast.Sub, ast.Mult, ast.Div, ast.Pow, ast.Mod)


def _eval(node):
    if isinstance(node, ast.Expression):
        return _eval(node.body)
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        return _d(node.value)
    if isinstance(node, ast.Name) and node.id in CONSTS:
        return CONSTS[node.id]
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.USub, ast.UAdd)):
        v = _eval(node.operand)
        return -v if isinstance(node.op, ast.USub) else v
    if isinstance(node, ast.BinOp) and isinstance(node.op, _BINOPS):
        a, b = _eval(node.left), _eval(node.right)
        op = node.op
        try:
            if isinstance(op, ast.Add):
                return a + b
            if isinstance(op, ast.Sub):
                return a - b
            if isinstance(op, ast.Mult):
                return a * b
            if isinstance(op, ast.Div):
                if b == 0:
                    raise CalcError("Sıfıra bölünemez")
                return a / b
            if isinstance(op, ast.Mod):
                if b == 0:
                    raise CalcError("Sıfıra bölünemez")
                return a % b
            if isinstance(op, ast.Pow):
                if b == b.to_integral_value() and abs(b) <= 10000:
                    if a == 0 and b < 0:
                        raise CalcError("Sıfıra bölünemez")
                    return a ** int(b)
                if a < 0:
                    raise CalcError("Negatif sayının kesirli kuvveti yok")
                return _d(float(a) ** float(b))
        except (InvalidOperation, DivisionByZero, OverflowError):
            raise CalcError("Sonuç çok büyük")
    if (isinstance(node, ast.Call) and isinstance(node.func, ast.Name)
            and node.func.id in FUNCS and len(node.args) == 1 and not node.keywords):
        return FUNCS[node.func.id](_eval(node.args[0]))
    raise CalcError("Geçersiz ifade")


def evaluate(expr):
    src = to_python(expr).strip()
    if not src:
        raise CalcError("Boş")
    try:
        tree = ast.parse(src, mode="eval")
    except SyntaxError:
        raise CalcError("Geçersiz ifade")
    return _eval(tree)


def fmt(x):
    """Decimal -> Turkce bicim: 1.234.567,89 ; cok buyuk/kucukte bilimsel."""
    if x.is_nan() or x.is_infinite():
        raise CalcError("Tanımsız")
    if x == 0:
        return "0"
    ax = abs(x)
    if ax >= Decimal("1e15") or ax < Decimal("1e-9"):
        mant, _, exp = f"{x:.10e}".partition("e")
        mant = mant.rstrip("0").rstrip(".")
        return mant.replace(".", ",") + "×10^" + str(int(exp))
    q = x.quantize(Decimal("1e-12")).normalize()
    sign = "-" if q < 0 else ""
    ip, _, fp = f"{abs(q):f}".partition(".")
    ip = f"{int(ip):,}".replace(",", ".")
    return sign + ip + ("," + fp if fp else "")


def raw(x):
    """Sonucu yeniden hesaplanabilir girdi olarak (binlik ayraci yok)."""
    s = fmt(x)
    if "×10^" in s:
        mant, exp = s.split("×10^")
        return f"{mant}×10^{exp}"
    return s.replace(".", "")


# ───────────────────────── Arayuz ─────────────────────────

STD_ROWS = [
    [("C", "clear", "danger"), ("( )", "paren", "op"), ("%", "%", "op"), ("÷", "÷", "op")],
    [("7", "7", "num"), ("8", "8", "num"), ("9", "9", "num"), ("×", "×", "op")],
    [("4", "4", "num"), ("5", "5", "num"), ("6", "6", "num"), ("−", "−", "op")],
    [("1", "1", "num"), ("2", "2", "num"), ("3", "3", "num"), ("+", "+", "op")],
    [("±", "neg", "num"), ("0", "0", "num"), (",", ",", "num"), ("=", "equals", "equals")],
]

SCI_ROWS = [
    [("√", "√(", "sci"), ("x²", "^2", "sci"), ("xʸ", "^", "sci")],
    [("sin", "sin(", "sci"), ("cos", "cos(", "sci"), ("tan", "tan(", "sci")],
    [("ln", "ln(", "sci"), ("log", "log(", "sci"), ("1/x", "inv", "sci")],
    [("π", "π", "sci"), ("e", "e", "sci"), ("|x|", "abs(", "sci")],
    [("(", "(", "sci"), (")", ")", "sci"), ("eˣ", "e^", "sci")],
]

KEYMAP = {
    "*": "×", "x": "×", "X": "×", "/": "÷", "-": "−", "+": "+", "^": "^", "%": "%",
    "(": "(", ")": ")", ",": ",", ".": ",",
}


class HesapWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Hesap Makinesi")
        self.set_default_size(380, 600)
        self.expr = ""
        self.just_evaluated = False
        self.last_result = None
        self.history = self._load_history()

        self.toasts = Adw.ToastOverlay()
        self.split = Adw.OverlaySplitView(sidebar_position=Gtk.PackType.END, show_sidebar=False,
                                          max_sidebar_width=300, sidebar_width_fraction=0.45)
        self.split.set_collapsed(True)

        toolbar = Adw.ToolbarView()
        header = Adw.HeaderBar()
        header.set_title_widget(Gtk.Label(label="Hesap Makinesi", css_classes=["title"]))

        self.sci_btn = Gtk.ToggleButton(icon_name="accessories-calculator-symbolic",
                                        tooltip_text="Bilimsel mod (Ctrl+B)")
        self.sci_btn.connect("toggled", self._on_sci_toggled)
        header.pack_start(self.sci_btn)

        hist_btn = Gtk.ToggleButton(icon_name="document-open-recent-symbolic",
                                    tooltip_text="Geçmiş (Ctrl+H)")
        hist_btn.bind_property("active", self.split, "show-sidebar",
                               GObject_BIND_BIDIRECTIONAL())
        header.pack_end(hist_btn)
        self.hist_btn = hist_btn

        toolbar.add_top_bar(header)
        toolbar.set_content(self._build_calc())
        self.split.set_content(toolbar)
        self.split.set_sidebar(self._build_history())
        self.toasts.set_child(self.split)
        self.set_content(self.toasts)

        # CAPTURE: tuslar odakli butona gitmeden once pencerede islenir (yoksa Enter odakli butonu "tiklar")
        keys = Gtk.EventControllerKey(propagation_phase=Gtk.PropagationPhase.CAPTURE)
        keys.connect("key-pressed", self._on_key)
        self.add_controller(keys)
        self._refresh()

    # ── Yapi ──
    def _build_calc(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10,
                      margin_start=14, margin_end=14, margin_bottom=14, margin_top=2)

        display = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4, css_classes=["hesap-display"],
                          vexpand=True)
        self.expr_label = Gtk.Label(xalign=1, wrap=True, wrap_mode=2, css_classes=["hesap-expr"],
                                    selectable=False, valign=Gtk.Align.END, vexpand=True)
        bottom = Gtk.Box(spacing=8)
        back = Gtk.Button(icon_name="edit-clear-symbolic", tooltip_text="Sil (Backspace)",
                          css_classes=["flat", "hesap-back"], valign=Gtk.Align.CENTER, focusable=False)
        back.connect("clicked", lambda *_: self.press("back"))
        self.preview_label = Gtk.Label(xalign=1, hexpand=True, ellipsize=1, css_classes=["hesap-preview"])
        bottom.append(back)
        bottom.append(self.preview_label)
        display.append(self.expr_label)
        display.append(bottom)
        box.append(display)

        keys = Gtk.Box(spacing=8, homogeneous=False)
        self.sci_revealer = Gtk.Revealer(transition_type=Gtk.RevealerTransitionType.SLIDE_RIGHT,
                                         reveal_child=False)
        self.sci_revealer.set_child(self._grid(SCI_ROWS))
        self.sci_revealer.connect("notify::child-revealed", self._on_sci_revealed)
        keys.append(self.sci_revealer)
        std = self._grid(STD_ROWS)
        std.set_hexpand(True)
        keys.append(std)
        box.append(keys)
        return box

    def _grid(self, rows):
        grid = Gtk.Grid(row_spacing=8, column_spacing=8, row_homogeneous=True, column_homogeneous=True)
        for r, row in enumerate(rows):
            for c, (label, action, kind) in enumerate(row):
                b = Gtk.Button(label=label, css_classes=["hesap-key", f"hesap-{kind}"], focusable=False)
                b.set_size_request(64 if kind != "sci" else 56, 58)
                b.connect("clicked", lambda _b, a=action: self.press(a))
                grid.attach(b, c, r, 1, 1)
        return grid

    def _build_history(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, css_classes=["hesap-history"])
        head = Gtk.Box(spacing=6, margin_start=12, margin_end=8, margin_top=10, margin_bottom=6)
        head.append(Gtk.Label(label="Geçmiş", xalign=0, hexpand=True, css_classes=["heading"]))
        clear = Gtk.Button(icon_name="user-trash-symbolic", tooltip_text="Geçmişi temizle",
                           css_classes=["flat"])
        clear.connect("clicked", self._clear_history)
        head.append(clear)
        box.append(head)

        self.hist_list = Gtk.ListBox(css_classes=["navigation-sidebar"],
                                     selection_mode=Gtk.SelectionMode.NONE)
        self.hist_list.set_placeholder(Gtk.Label(label="Henüz hesap yok", css_classes=["dim-label"],
                                                 margin_top=20))
        self.hist_list.connect("row-activated", self._on_history_row)
        scroll = Gtk.ScrolledWindow(vexpand=True, hscrollbar_policy=Gtk.PolicyType.NEVER)
        scroll.set_child(self.hist_list)
        box.append(scroll)
        self._fill_history()
        return box

    # ── Gecmis ──
    def _load_history(self):
        try:
            with open(HISTORY_FILE) as f:
                return json.load(f)[-HISTORY_MAX:]
        except (OSError, ValueError):
            return []

    def _save_history(self):
        os.makedirs(os.path.dirname(HISTORY_FILE), exist_ok=True)
        with open(HISTORY_FILE, "w") as f:
            json.dump(self.history[-HISTORY_MAX:], f, ensure_ascii=False)

    def _fill_history(self):
        while (row := self.hist_list.get_row_at_index(0)) is not None:
            self.hist_list.remove(row)
        for item in reversed(self.history):
            row = Gtk.ListBoxRow(activatable=True)
            row.item = item
            v = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2,
                        margin_start=8, margin_end=8, margin_top=6, margin_bottom=6)
            v.append(Gtk.Label(label=item["expr"], xalign=1, ellipsize=1, css_classes=["dim-label", "caption"]))
            v.append(Gtk.Label(label="= " + item["result"], xalign=1, ellipsize=1, css_classes=["hesap-hist-result"]))
            row.set_child(v)
            row.set_tooltip_text("Tıkla: sonucu kullan")
            self.hist_list.append(row)

    def _on_history_row(self, _list, row):
        self.expr = row.item["raw"]
        self.just_evaluated = True
        self._refresh()
        if self.split.get_collapsed():
            self.hist_btn.set_active(False)

    def _clear_history(self, *_):
        self.history = []
        self._save_history()
        self._fill_history()

    # ── Girdi ──
    def press(self, action):
        if action == "clear":
            self.expr = ""
        elif action == "back":
            self.expr = self.expr[:-1]
        elif action == "equals":
            self._equals()
            return
        elif action == "paren":
            opens = self.expr.count("(") - self.expr.count(")")
            last = self.expr[-1:]
            if opens > 0 and (last.isdigit() or last in ")πe%"):
                self._append(")")
            else:
                self._append("(")
        elif action == "neg":
            self._negate_last()
        elif action == "inv":
            self.expr = f"1÷({self.expr})" if self.expr else "1÷("
        else:
            self._append(action)
            return
        self.just_evaluated = False
        self._refresh()

    def _append(self, s):
        if self.just_evaluated:
            # sonuctan sonra rakam: yeni hesap; operator: sonuctan devam
            if s[:1].isdigit() or s[:1] in ",(πe√" or s.endswith("("):
                self.expr = ""
        self.just_evaluated = False
        if s == "," and re.search(r",\d*$", self.expr):
            return  # ayni sayida ikinci ondalik ayraci
        ops = "+−×÷^"
        if s in ops and self.expr[-1:] in ops:
            self.expr = self.expr[:-1]  # operator degistir
        if s in "×÷^%" and not self.expr:
            return
        self.expr += s
        self._refresh()

    def _negate_last(self):
        m = re.search(r"(\(−)?(\d+(?:,\d*)?)$", self.expr)
        if not m:
            self._append("−")
            return
        if m.group(1):
            self.expr = self.expr[:m.start()] + m.group(2)
        else:
            self.expr = self.expr[:m.start(2)] + "(−" + m.group(2)

    def _equals(self):
        if not self.expr:
            return
        try:
            value = evaluate(self.expr)
            result = fmt(value)
        except CalcError as e:
            self._show_error(str(e))
            return
        self.history.append({"expr": self._pretty(self.expr), "result": result, "raw": raw(value)})
        self._save_history()
        self._fill_history()
        self.last_result = result
        self.expr = raw(value)
        self.just_evaluated = True
        self._refresh(evaluated=True)

    def _show_error(self, msg):
        self.preview_label.set_label(msg)
        self.preview_label.add_css_class("hesap-error")
        self.expr_label.add_css_class("shake")
        GLib.timeout_add(400, lambda: (self.expr_label.remove_css_class("shake"), False)[1])

    @staticmethod
    def _pretty(expr):
        """Gosterim: sayilara binlik ayraci ekle."""
        def group(m):
            ip, _, fp = m.group(0).partition(",")
            return f"{int(ip):,}".replace(",", ".") + ("," + fp if _ else "")
        return re.sub(r"\d+(?:,\d*)?", group, expr)

    def _refresh(self, evaluated=False):
        self.expr_label.set_label(self._pretty(self.expr) if self.expr else "0")
        self.expr_label.set_css_classes(["hesap-expr", "hesap-result"] if evaluated else ["hesap-expr"])
        self.preview_label.remove_css_class("hesap-error")
        preview = ""
        if self.expr and not evaluated:
            try:
                v = evaluate(self.expr)
                if raw(v) != self.expr:
                    preview = "= " + fmt(v)
            except CalcError:
                pass
        self.preview_label.set_label(preview)

    # ── Klavye ──
    def _on_key(self, _ctl, keyval, _code, state):
        ctrl = state & Gdk.ModifierType.CONTROL_MASK
        name = Gdk.keyval_name(keyval) or ""
        if ctrl and name in ("c", "C"):
            self._copy()
            return True
        if ctrl and name in ("h", "H"):
            self.hist_btn.set_active(not self.hist_btn.get_active())
            return True
        if ctrl and name in ("b", "B"):
            self.sci_btn.set_active(not self.sci_btn.get_active())
            return True
        if ctrl:
            return False
        if name in ("Return", "KP_Enter", "equal", "KP_Equal"):
            self.press("equals")
        elif name == "BackSpace":
            self.press("back")
        elif name in ("Escape", "Delete"):
            self.press("clear")
        else:
            ch = chr(Gdk.keyval_to_unicode(keyval) or 0)
            if ch.isdigit():
                self._append(ch)
            elif ch in KEYMAP:
                self._append(KEYMAP[ch])
            elif ch in ("p", "P"):
                self._append("π")
            elif ch == "e":
                self._append("e")
            elif ch in ("s", "S"):
                self._append("√(")
            else:
                return False
        return True

    def _copy(self):
        text = self.last_result if self.just_evaluated and self.last_result else None
        if text is None:
            try:
                text = fmt(evaluate(self.expr))
            except CalcError:
                return
        Gdk.Display.get_default().get_clipboard().set(text)
        self.toasts.add_toast(Adw.Toast(title=f"Kopyalandı: {text}", timeout=2))

    def _on_sci_toggled(self, btn):
        on = btn.get_active()
        self.sci_revealer.set_reveal_child(on)
        if on:
            self._resize(600)
        # kapanirken: panel kayma animasyonu bitince kucult (yoksa GTK minimum genislik izin vermez)

    def _on_sci_revealed(self, revealer, _pspec):
        if not revealer.get_child_revealed() and not self.sci_btn.get_active():
            self._resize(380)

    def _resize(self, width):
        self.set_default_size(width, self.get_height())
        # Wayland'de uygulama acik pencereyi kendisi kucultemez; Hyprland'den iste
        cmd = (f'hl.dsp.window.resize({{ window = "pid:{os.getpid()}", '
               f'x = {width}, y = {self.get_height()}, relative = false }})')
        try:
            Gio.Subprocess.new(["hyprctl", "dispatch", cmd],
                               Gio.SubprocessFlags.STDOUT_SILENCE | Gio.SubprocessFlags.STDERR_SILENCE)
        except GLib.Error:
            pass


def GObject_BIND_BIDIRECTIONAL():
    from gi.repository import GObject
    return GObject.BindingFlags.BIDIRECTIONAL | GObject.BindingFlags.SYNC_CREATE


class HesapApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id=APP_ID, flags=Gio.ApplicationFlags.DEFAULT_FLAGS)

    def do_startup(self):
        Adw.Application.do_startup(self)
        theme.apply("hesap.css")

    def do_activate(self):
        win = self.get_active_window() or HesapWindow(self)
        win.present()


def main():
    return HesapApp().run(sys.argv)
