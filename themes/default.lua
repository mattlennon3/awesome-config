-- ===================================================================
-- Initialization
-- ===================================================================

-- awesome default theme assets
local theme_assets = require("beautiful.theme_assets")

-- Note that xft.dpi must be properly assigned in the .Xresources file if you are using a high DPI screen
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


-- define module table
local theme = require('themes.common')

-- Font
theme.font = "JetBrains Mono Medium 8"

theme.bg_normal     = "#222222"
theme.bg_open       = "#444444"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#BC3908"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_open       = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.button_bg = theme.bg_open
theme.button_border_width = dpi(1)
theme.button_border = theme.border_normal


-- Taglist
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_focus = theme.bg_focus
-- Generate taglist squares:
local taglist_square_size = dpi(3)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = theme.bg_open
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_open


-- Panel Sizing
theme.wibar_height = dpi(13)

-- Notification Sizing
theme.notification_icon_size = 150
theme.notification_max_width = 600




-- return theme
return theme
