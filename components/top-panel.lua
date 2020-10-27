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


-- Create a textclock widget

-- local clock = wibox.widget.textclock()
-- https://unix.stackexchange.com/a/519655/358471
clock_format = "%a %Y-%m-%d %H:%M %Z"
-- utc_textclock = wibox.widget.textclock(" " .. clock_format, nil, "Z")
local_textclock = wibox.widget.textclock(" — " .. clock_format .. " ")


local systray = wibox.widget.systray()


local top_panel = {}

-- only need for debug
local gears = require("gears")

-- ===================================================================
-- Import Widgets
-- ===================================================================

-- local task_list = require("widgets.task-list")

-- Volume
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volumebar-widget
local volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")
-- https://github.com/horst3180/arc-icon-theme#installation
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local previousVolume = "80%"
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
local BAT0 = battery_widget { adapter = "BAT1", ac = "ACAD" }

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
        --   utc_textclock,
          local_textclock,
          awful.widget.layoutbox(s)
       }
    }

end

return top_panel
