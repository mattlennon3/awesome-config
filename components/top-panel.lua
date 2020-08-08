-- ===================================================================
-- Initialization
-- ===================================================================
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local keys = require("keys")



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
        filter = awful.widget.tasklist.filter.currenttags
        -- buttons = tasklist_buttons
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
       layout = wibox.layout.fixed.horizontal,
       task_list,
       },
       {-- Right widgets
          layout = wibox.layout.fixed.horizontal,
          
          systray,
          clock,
          awful.widget.layoutbox(s)
       }
    }

    -- hide panel when client is fullscreen
    client.connect_signal('property::fullscreen',
                          function(c) panel.visible = not c.fullscreen end)

end

return top_panel
