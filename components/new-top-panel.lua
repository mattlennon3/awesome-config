local new_top_panel = {}
local lookup_icon = require("menubar.utils").lookup_icon
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local tag_list = require("components.panel.taglist")

local keys = require("keys")


new_top_panel.create = function (awful_screen)

    -- https://github.com/undefinedDarkness/rice/blob/master/.config/awesome/components/hello_user.lua#L53
    function app_launcher(icon)
        icon = lookup_icon(icon)
        local w = wibox.widget {
            widget = wibox.widget.imagebox,
            image = icon,
            resize = true,
            forced_height = 20,
            forced_width = 20
        }
        return w
    end

    awful_screen.mywibox = awful.wibar({ 
        position = beautiful.wibar_position, 
        screen = awful_screen,
        height = beautiful.wibar_height 
    })

    -- Add widgets to the wibox
    awful_screen.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            tag_list(awful_screen, keys.taglist_buttons),
        },
        -- require("widgets.panel.tasklist")(s), 
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
        },
    }


    -- awful.popup {
    --     widget = app_launcher('firefox'),
    --     bg = beautiful.transparent,
    --     shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    --     hide_on_right_click = true,
    -- }


    -- local panel = awful.wibar({
    --     screen = screen,
    --     position = 'top',
    --     height = beautiful.wibar_height,
    --     bg = beautiful.bg_normal
    -- })

    -- panel:setup {
    --     {app_launcher("minecraft-launcher")}
    -- }

end

return new_top_panel
