-- ===================================================================
-- Initialization
-- ===================================================================
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local keys = require("config.keys")

-- Note that xft.dpi must be properly assigned in the .Xresources file if you are using a high DPI screen
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local device = os.getenv("ML_DEVICE")

-- Default Applications
local apps = require("config.apps").default

-- Import logger
local logger = require("utils.log")

-- ===================================================================
-- Import Widgets
-- ===================================================================

local top_panel = {} 

local systray = wibox.widget.systray()

local cpu_temp = require("components.panel.cpu_temp")

-- Create a textclock widget

-- https://unix.stackexchange.com/a/519655/358471
local date_format = "%a %Y-%m-%d"
local short_clock = "%H:%M %Z"
local date_textclock = wibox.widget.textclock(" " .. date_format .. " ")
local local_textclock = wibox.widget.textclock(" " .. short_clock .. " ", nil)
local est_textclock = wibox.widget.textclock(" " .. short_clock .. " ", nil, "EST")
local tokyo_textclock = wibox.widget.textclock(" " .. short_clock .. " ", nil, "JST-9")

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

-- ===================================================================
-- Reload Macro keys
-- ===================================================================

local reload_macro_button = wibox.widget {
    {
        image = beautiful.macro_keypad_reload_icon,
        resize = true,
        forced_height = beautiful.wibar_height,
        widget = wibox.widget.imagebox
    },
    margins = 2,
    widget = wibox.container.margin
}

reload_macro_button:connect_signal("button::press", function(_,_,_,button)
    -- button 1 is left click, described in keys.lua
    if (button == 1) then awful.spawn.easy_async_with_shell(apps.scripts.keypadRemap, function() end) end
end)


-- ===================================================================
-- CPU Meter
-- ===================================================================

-- -- sensors | grep -ioP "Tctl:\s+\+\K(.*)"
-- -- To use pipe (|) in commands, must be wrapped in bash -c first.
-- local cpu_temp = awful.widget.watch('bash -c \'sensors | grep -ioP "Tctl:\\s+\\+\\K(.*)"\'', 5, function (widget, stdout)
--     -- TODO: Nice icon
--     widget:set_text(" " .. stdout)
-- end)


-- ===================================================================
-- Keyboard Indicator
-- ===================================================================

local kb_context_timeout = 10

local kb_context = awful.widget.watch('/home/matt/scripts/virt-manager/keyboard_state.sh', kb_context_timeout, function (widget, stdout)
    local text = ""
    for line in stdout:gmatch("[^\r\n]+") do -- Had to do this to get the echo from the script
        if line == "guest" then
            text = "-G-"
        elseif line == "host" then
            text = "-H-"
        else
            -- vm not running
            text = " "
        end
        -- keyboard_vm_indicator.icon:set_image(PATH_TO_ICONS .. widget_icon_name .. ".svg")
    end
    widget:set_text(text)
end)

-- For faster updates than watch, get the state change as it happens
awesome.connect_signal("kb_state_change", function (state)
    local text = ""
    if state == "guest" then
        text = "-G-"
    elseif state == "host" then
        text = "-H-"
    else
        -- vm not running
        text = " "
    end
    kb_context:set_text(text)
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
        height = beautiful.wibar_height,
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
          kb_context,
          cpu_temp,
          systray,
          date_textclock,
          tokyo_textclock,
          est_textclock,
          local_textclock,
          reload_macro_button,
          awful.widget.layoutbox(s)
       }
    }

end

return top_panel
