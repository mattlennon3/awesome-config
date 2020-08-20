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
local clock = wibox.widget.textclock()

local systray = wibox.widget.systray()


local top_panel = {}

-- only need for debug
local gears = require("gears")

-- import widgets
-- local task_list = require("widgets.task-list")

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
          layout = wibox.layout.fixed.horizontal,
          systray,
          clock,
          awful.widget.layoutbox(s)
       }
    }

end

return top_panel
