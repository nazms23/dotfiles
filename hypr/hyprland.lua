-- Hyprland Lua config (0.55+, 0.57'de hyprlang kaldirildi).
-- Wiki: https://wiki.hypr.land/Configuring/Start/

-------------------
--- CATPPUCCIN ---
-------------------

local c = require("catppuccin-mocha")

-- Dinamik accent (wallpaper'dan): accent-apply.sh uretir. Yoksa Catppuccin green/teal.
local ok, acc = pcall(require, "accent")
if not ok or type(acc) ~= "table" then
    acc = { accent = c.green, accent2 = c.teal }
end


----------------
--- MONITORS ---
----------------

-- HDMI monitor solda, laptop sağda
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60",  position = "0x0",    scale = 1 })
hl.monitor({ output = "eDP-1",    mode = "1920x1080@144", position = "1920x0", scale = 1 })


-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "~/.local/bin/baslatici"  -- github.com/nazms23/baslatici (arka planda bekler, aninda acilir)


-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("awww-daemon && awww img ~/wallpaper.png --transition-type grow --transition-duration 1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprswitch init --show-title --custom-css ~/.config/hypr/hyprswitch.css")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 3 && kando")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("~/.local/bin/baslatici --daemon")
    hl.exec_cmd("sleep 2 && ~/.config/hypr/update-accent.sh")
    hl.exec_cmd("~/.config/hypr/power-watch.sh")
end)


-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-green-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-green-cursors")

-- Qt theming (Kvantum + Catppuccin)
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Electron Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
-- Kando 3.x AUR baslaticisi varsayilan x11 (XWayland) aciyor, native Wayland'e zorla
hl.env("KANDO_OZONE_PLATFORM", "wayland")

-- GTK Catppuccin tema
hl.env("GTK_THEME", "catppuccin-mocha-green-standard+default")


---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 14,

        border_size = 2,

        col = {
            active_border   = { colors = { acc.accent, acc.accent2 }, angle = 45 },
            inactive_border = c.surface0,
        },

        resize_on_border = true,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.92,
        dim_inactive     = true,
        dim_strength     = 0.12,

        shadow = {
            enabled      = true,
            range        = 15,
            render_power = 3,
            color        = "rgba(1e1e2eee)",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            vibrancy          = 0.2,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    -- Guncelleme sonrasi "what's new" penceresini ve bagis hatirlatmasini kapat
    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

hl.curve("smoothOut",      { type = "bezier", points = { {0.36, 0},    {0.66, -0.56} } })
hl.curve("smoothIn",       { type = "bezier", points = { {0.25, 1},    {0.5, 1}      } })
hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.1}    } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.22, 1},    {0.36, 1}     } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0},    {0.35, 1}     } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}        } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}     } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}      } })
hl.curve("easeOutBack",    { type = "bezier", points = { {0.34, 1.56}, {0.64, 1}     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- Lua'da speed max 100 (eski conf'ta 120'ydi)
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100,  bezier = "linear",       style = "loop" })
hl.animation({ leaf = "windows",       enabled = true, speed = 5.5,  bezier = "overshot",     style = "popin 87%" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 5,    bezier = "easeOutBack",  style = "popin 85%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2.5,  bezier = "smoothOut",    style = "popin 75%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2.5,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 2,    bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.5,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 4.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4.5,  bezier = "easeOutBack",  style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2,    bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2.5,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2,    bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 5,    bezier = "overshot",     style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 5,    bezier = "overshot",     style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5,    bezier = "overshot",     style = "slide" })


------------------------------------
--- PIL / OYUN MODU (dinamik)    ---
------------------------------------

-- Sarj adaptoru (/sys/class/power_supply/*: type=Mains). Bulunamazsa prizde varsay.
local function read_line(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local v = f:read("*l")
    f:close()
    return v
end

local function on_ac()
    local p = io.popen("ls /sys/class/power_supply 2>/dev/null")
    if p then
        for dev in p:lines() do
            local base = "/sys/class/power_supply/" .. dev
            if read_line(base .. "/type") == "Mains" then
                p:close()
                return read_line(base .. "/online") == "1"
            end
        end
        p:close()
    end
    return true
end

local ac_at_load = on_ac()

-- Pilde: kenarlik donme animasyonu (loop, ekrani surekli 144 Hz yeniden cizdirir) kapali, blur hafif
if not ac_at_load then
    hl.animation({ leaf = "borderangle", enabled = false })
    hl.config({ decoration = { blur = { passes = 1 } } })
end

-- Sarj durumu degisince reload: power-watch.sh (udev olayi). hl.timer'i config yuklenirken
-- olusturmak --verify-config'i cokertiyor (0.57), o yuzden izleme disarida.

-- Oyun modu: gamemode.sh durum dosyasini olusturur/siler ve reload eder (SUPER+F1)
local gamemode_file = io.open(os.getenv("HOME") .. "/.cache/hypr-gamemode", "r")
if gamemode_file then
    gamemode_file:close()
    hl.config({
        animations = { enabled = false },
        decoration = {
            blur         = { enabled = false },
            shadow       = { enabled = false },
            dim_inactive = false,
            inactive_opacity = 1.0,
        },
        general = { gaps_in = 0, gaps_out = 0 },
    })
end


-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "tr,us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

-- Bind yardimcisi. Aciklama formati "Kategori: Ne yapar" -> SUPER+H yardim ekrani
-- (keybinds-help.sh) bunu hyprctl binds'tan okuyup gruplar. "[...]" ile tus gosterimi
-- ozellestirilebilir (ornegin 4 yon tusunu tek satirda gostermek icin).
-- Aciklamasi olmayan bind yardimda gorunmez.
local function bind(keys, dsp, desc, opts)
    opts = opts or {}
    if desc then opts.description = desc end
    return hl.bind(keys, dsp, opts)
end

-- Genel
bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal),    "Genel: Terminal (kitty)")
bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), "Genel: Dosya yöneticisi (Dolphin)")
bind(mainMod .. " + R", hl.dsp.exec_cmd(menu),        "Genel: Uygulama başlatıcı (favori, klasör, = hesap, > komut)")
bind(mainMod .. " + D", hl.dsp.global("kando:example-menu"), "Genel: Kando pie menü")
bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper --backend awww --folder ~/Wallpapers"), "Genel: Duvar kağıdı seç (accent otomatik)")
bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/hypr/keybinds-help.sh"), "Genel: Bu yardım ekranı")
bind(mainMod .. " + F1", hl.dsp.exec_cmd("~/.config/hypr/gamemode.sh toggle"), "Genel: Oyun modu (blur/animasyon/gölge kapat-aç)")
bind("XF86Calculator", hl.dsp.exec_cmd("~/.local/bin/hesap-makinesi"), "Genel: [Hesap makinesi tuşu] Hesap makinesi")

-- Pencere
bind(mainMod .. " + C", hl.dsp.window.close(), "Pencere: Kapat")
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), "Pencere: Tam ekran")
bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), "Pencere: Yüzen / döşeli")
bind(mainMod .. " + P", hl.dsp.window.pseudo(), "Pencere: Pseudo (boyutu koru)")
bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), "Pencere: Bölmeyi çevir (yatay/dikey)")
bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }),  "Pencere: [SUPER + ←↑↓→] Odağı taşı")
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), "Pencere: [SUPER + CTRL + ←↑↓→] Boyutlandır", { repeating = true })
bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), nil, { repeating = true })
bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), nil, { repeating = true })
bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), nil, { repeating = true })
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   "Pencere: [SUPER + Sol tık sürükle] Taşı",       { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), "Pencere: [SUPER + Sağ tık sürükle] Boyutlandır", { mouse = true })

-- Pencere gecisi ve workspace'ler
bind("ALT + TAB", hl.dsp.exec_cmd("hyprswitch gui --mod-key ALT --key TAB --close mod-key-release --reverse-key=mod=SHIFT --sort-recent true"),
    "Workspace: [ALT + TAB] Pencere değiştir (SHIFT ile geri)")
bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprswitch gui --mod-key SUPER --key A --switch-type workspace --close default"),
    "Workspace: Genel bakış (workspace seç, Enter/tık)")
for i = 1, 10 do
    local key = i % 10
    bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }),       i == 1 and "Workspace: [SUPER + 1…0] Workspace'e git" or nil)
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), i == 1 and "Workspace: [SUPER + SHIFT + 1…0] Pencereyi workspace'e taşı" or nil)
end
-- Scratchpad: gizli workspace. Pencere oraya gidince ortada yuzen (%70) olur,
-- geri alininca eski haline (doseli/yuzen) doner. Durum tablosu reload'da sifirlanir.
local SCRATCH = "special:scratch"
local scratch_was_tiled = {}

bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratch"), "Workspace: Scratchpad'i göster / gizle")
bind(mainMod .. " + CTRL + S", function()
    local win = hl.get_active_window()
    if not win then return end
    local sel = "address:" .. win.address

    if win.workspace and win.workspace.name == SCRATCH then
        local ws = hl.get_active_workspace()
        hl.dispatch(hl.dsp.window.move({ window = sel, workspace = ws.id }))
        if scratch_was_tiled[win.address] then
            hl.dispatch(hl.dsp.window.float({ window = sel, action = "disable" }))
        end
        scratch_was_tiled[win.address] = nil
    else
        scratch_was_tiled[win.address] = not win.floating
        hl.dispatch(hl.dsp.window.move({ window = sel, workspace = SCRATCH, follow = false }))
        hl.dispatch(hl.dsp.window.float({ window = sel, action = "enable" }))
        if win.monitor then
            hl.dispatch(hl.dsp.window.resize({ window = sel, x = math.floor(win.monitor.width * 0.7),
                                               y = math.floor(win.monitor.height * 0.7), relative = false }))
        end
        hl.dispatch(hl.dsp.window.center({ window = sel }))
    end
end, "Workspace: Pencereyi scratchpad'e at / geri al")

bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "+1" }), "Workspace: Sonraki")
bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "-1" }), "Workspace: Önceki")
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Workspace: [SUPER + Tekerlek] Workspace'ler arası gez")
bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Sistem
bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), "Sistem: Ekranı kilitle")
bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout -b 5 -T 400 -B 400 --protocol layer-shell"), "Sistem: Güç menüsü (kapat/uyku/çıkış)")
bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"), "Sistem: Kontrol merkezi (bildirim, WiFi, BT, gece ışığı)")
bind(mainMod .. " + V", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -p "Pano" | cliphist decode | wl-copy'), "Sistem: Pano geçmişi")
bind(mainMod .. " + F11", hl.dsp.exec_cmd("networkmanager_dmenu"), "Sistem: WiFi ağları (rofi)")

-- Ekran goruntusu ve OCR
bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh region"), "Ekran: Alan seç → panoya (bildirimden Düzenle/Kaydet)")
bind("Print", hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh full"), "Ekran: Tüm ekran → ~/Screenshots")
bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh auto"), "Ekran: OCR, alandaki metni kopyala (otomatik dil)")
bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh jpn"),  "Ekran: OCR (Japonca)")
bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh menu"), "Ekran: OCR dil seçici")

-- Klavyeyle fare (SUPER+ALT + hjkl = hareket, u = sol tik, y = sag tik)
bind(mainMod .. " + ALT + h", hl.dsp.exec_cmd("ydotool mousemove -x -8 -y 0"), "Fare: [SUPER + ALT + H J K L] İmleci taşı", { repeating = true })
bind(mainMod .. " + ALT + l", hl.dsp.exec_cmd("ydotool mousemove -x 8 -y 0"),  nil, { repeating = true })
bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y -8"), nil, { repeating = true })
bind(mainMod .. " + ALT + j", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y 8"),  nil, { repeating = true })
bind(mainMod .. " + ALT + u", hl.dsp.exec_cmd("ydotool click 0xC0"), "Fare: Sol tık")
bind(mainMod .. " + ALT + y", hl.dsp.exec_cmd("ydotool click 0xC1"), "Fare: Sağ tık")

-- Medya tuslari
bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise --max-volume 150"), "Medya: [Ses / Parlaklık tuşları] OSD ile ayarla", { locked = true, repeating = true })
bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       nil, { locked = true, repeating = true })
bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), nil, { locked = true })
bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  nil, { locked = true })
bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          nil, { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          nil, { locked = true, repeating = true })
bind("Caps_Lock",             hl.dsp.exec_cmd("sleep 0.1 && ~/.config/hypr/lockkey-osd.sh caps"), nil, { locked = true })
bind("Num_Lock",              hl.dsp.exec_cmd("sleep 0.1 && ~/.config/hypr/lockkey-osd.sh num"),  nil, { locked = true })
bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       "Medya: [Medya tuşları] Oynat / duraklat / sonraki / önceki", { locked = true })
bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), nil, { locked = true })
bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), nil, { locked = true })
bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   nil, { locked = true })

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Yad help dialog float
hl.window_rule({
    name   = "yad-float",
    match  = { class = "^(yad)$" },
    float  = true,
    center = true,
})

-- Rofi float
hl.window_rule({
    name  = "rofi-float",
    match = { class = "^(Rofi)$" },
    float = true,
})

-- System monitor float
hl.window_rule({
    name   = "sysmonitor-float",
    match  = { class = "^(sysmonitor)$" },
    float  = true,
    size   = { "monitor_w*0.6", "monitor_h*0.7" },
    center = true,
})

-- pavucontrol float
hl.window_rule({
    name   = "pavucontrol-float",
    match  = { class = "^(org.pulseaudio.pavucontrol)$" },
    float  = true,
    size   = { "monitor_w*0.4", "monitor_h*0.5" },
    center = true,
})

-- Baslatici (github.com/nazms23/baslatici): panel buzlu cam; tam ekran karartma (alpha 0.28) blur disi
hl.layer_rule({
    name         = "baslatici-blur",
    match        = { namespace = "^baslatici$" },
    blur         = true,
    ignore_alpha = 0.5,
})

-- Hesap makinesi (github.com/nazms23/hesap-makinesi): kucuk yuzen pencere
hl.window_rule({
    name   = "hesap-makinesi-float",
    match  = { class = "^(io\\.github\\.nazms23\\.HesapMakinesi)$" },
    float  = true,
    size   = { 380, 600 },
    center = true,
})

-- Picture-in-Picture
hl.window_rule({
    name  = "pip-float",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin   = true,
    size  = { "monitor_w*0.3", "monitor_h*0.3" },
    move  = { "monitor_w*0.68", "monitor_h*0.67" },
})

-- Kando pie menu (3.x, Electron 43 / native Wayland - class: menu.kando.Kando)
hl.window_rule({
    name     = "kando-menu",
    match    = { class = "^(menu\\.kando\\.Kando)$", title = "^(Kando Menu)$" },
    float    = true,
    pin      = true,
    decorate = false,
    no_anim  = true,
})

