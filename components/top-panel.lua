-- ===================================================================
-- Initialization
-- ===================================================================
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local keys = require("keys")

-- Note that xft.dpi must be properly assigned in the .Xresources file if you are using a high DPI screen
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local device = os.getenv("ML_DEVICE")

-- Default Applications
local apps = require("apps").default

-- only need for debug
local gears = require("gears")

-- ===================================================================
-- Import Widgets
-- ===================================================================

local top_panel = {} 

local systray = wibox.widget.systray()

-- Create a textclock widget

-- https://unix.stackexchange.com/a/519655/358471
local date_format = "%a %Y-%m-%d"
local short_clock = "%H:%M %Z"
local date_textclock = wibox.widget.textclock(" " .. date_format .. " ")
local local_textclock = wibox.widget.textclock(" " .. short_clock .. " ", nil)
local est_textclock = wibox.widget.textclock(" " .. short_clock .. " ", nil, "EST")

local volumebar_widget
local BAT0

if device == "thinkbook" then
    -- Volume
    -- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volumebar-widget
    volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")
    -- https://github.com/horst3180/arc-icon-theme#installation
    -- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget
    volumebar_widget = volumebar_widget({
        main_color = '#dedede',
        mute_color = '#9e9e9e',
        width = 80,
        shape = 'rounded_bar', -- octogon, hexagon, powerline, etc
        -- bar's height = wibar's height minus 2x margins
        margins = 3
    })

    -- Battery Widget
    local battery_widget = require("battery-widget")
    BAT0 = battery_widget { adapter = "BAT1", ac = "ACAD" }

end

local reload_macro_button = wibox.widget {
    {
        image = beautiful.macro_keypad_reload_icon,
        resize = true,
        forced_height = beautiful.top_panel_height,
        widget = wibox.widget.imagebox
    },
    margins = 2,
    widget = wibox.container.margin
}

reload_macro_button:connect_signal("button::press", function(_,_,_,button)
    -- button 1 is left click, described in apps
    if (button == 1) then awful.spawn.easy_async_with_shell(apps.scripts.keyboardToggle, function() end) end
end)

-- ===================================================================
-- Bar Creation
-- ===================================================================

top_panel.create = function(s)
    -- Tags
    local tag_list = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = keys.taglist_buttons
    }

    -- Tasks (running apps)
    local task_list = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = keys.tasklist_buttons,
        -- tasklist_bg_normal = beautiful.bg_urgent,
        layout = {
            spacing_widget = {
                {
                    forced_width  = dpi(1),
                    forced_height = dpi(20),
                    thickness     = 1,
                    color         = beautiful.bg_normal,
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 10,
            layout  = wibox.layout.flex.horizontal
        },

    }

    local panel = awful.wibar({
        screen = s,
        position = 'top',
        height = beautiful.top_panel_height,
        bg = beautiful.bg_normal
    })

    -- Not having layout in each of the 2nd param objects crashes awesome with a cryptic error
    panel:setup {
       layout = wibox.layout.align.horizontal,
       {-- Left widgets
          layout = wibox.layout.fixed.horizontal,
          tag_list
       },
       {-- Middle Widgets
          layout = wibox.layout.flex.horizontal,
          task_list,
       },
       {-- Right widgets
          volumebar_widget,
          BAT0,
          layout = wibox.layout.fixed.horizontal,
          systray,
          date_textclock,
          est_textclock,
          local_textclock,
          reload_macro_button,
          awful.widget.layoutbox(s)
       }
    }

end

return top_panel
