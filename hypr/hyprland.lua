-- Hyprland Lua config (0.55+, 0.57'de hyprlang kaldirildi).
-- Wiki: https://wiki.hypr.land/Configuring/Start/

-------------------
--- CATPPUCCIN ---
-------------------

local c = require("catppuccin-mocha")


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
local menu        = "rofi -show drun -show-icons"


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
    hl.exec_cmd("sleep 4 && eww daemon")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("sleep 2 && ~/.config/hypr/update-accent.sh")
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
            active_border   = { colors = { c.green, c.teal }, angle = 45 },
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


-- NOT: hyprexpo plugin'i Hyprland 0.55'te resmi depodan kaldirildi (bakimsiz).
-- Workspace overview artik hyprswitch ile yapiliyor (SUPER+A) - plugin gerektirmez.


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

-- Core
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout -b 5 -T 400 -B 400 --protocol layer-shell"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Keybindings help
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/hypr/keybinds-help.sh"))

-- Wallpaper picker
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper --backend awww --folder ~/Wallpapers"))

-- Alt-Tab style window switcher (hyprswitch 5.x: modifier'lar BUYUK harf)
hl.bind("ALT + TAB", hl.dsp.exec_cmd("hyprswitch gui --mod-key ALT --key TAB --close mod-key-release --reverse-key=mod=SHIFT --sort-recent true"))

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Clipboard manager
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy'))

-- Notification center
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Kando pie menu (3.x: global shortcut app id "kando", pencere class'i hala menu.kando.Kando)
hl.bind(mainMod .. " + D", hl.dsp.global("kando:example-menu"))

-- WiFi manager
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("networkmanager_dmenu"))

-- EWW masaustu widget toggle
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("eww open --toggle desktop-widget"))

-- SUPER+A bos - hyprexpo 0.55'te kaldirildi, workspace overview yok

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Screenshots/$(date +%Y%m%d_%H%M%S).png"))

-- OCR - ekrandan metin tanima (alan secip panoya kopyalar)
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh auto"))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh jpn"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/.config/hypr/ocr.sh menu"))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces / move to workspace (0 = workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Sıradaki/önceki workspace
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "-1" }))

-- Mouse workspace scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize with keyboard
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), { repeating = true })

-- Mouse emulation with keyboard (SUPER+ALT + hjkl = move, u = left click, y = right click)
hl.bind(mainMod .. " + ALT + h", hl.dsp.exec_cmd("ydotool mousemove -x -8 -y 0"), { repeating = true })
hl.bind(mainMod .. " + ALT + l", hl.dsp.exec_cmd("ydotool mousemove -x 8 -y 0"),  { repeating = true })
hl.bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y -8"), { repeating = true })
hl.bind(mainMod .. " + ALT + j", hl.dsp.exec_cmd("ydotool mousemove -x 0 -y 8"),  { repeating = true })
hl.bind(mainMod .. " + ALT + u", hl.dsp.exec_cmd("ydotool click 0xC0"))
hl.bind(mainMod .. " + ALT + y", hl.dsp.exec_cmd("ydotool click 0xC1"))

-- Media keys
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise --max-volume 150"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),                  { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),            { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),             { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),                     { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),                     { locked = true, repeating = true })
hl.bind("Caps_Lock",             hl.dsp.exec_cmd("sleep 0.1 && ~/.config/hypr/lockkey-osd.sh caps"),       { locked = true })
hl.bind("Num_Lock",              hl.dsp.exec_cmd("sleep 0.1 && ~/.config/hypr/lockkey-osd.sh num"),        { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                                        { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),                                  { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                                  { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                                    { locked = true })


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

-- EWW popups
hl.window_rule({
    name     = "eww-popups",
    match    = { class = "^(eww)$" },
    float    = true,
    pin      = true,
    decorate = false,
})
