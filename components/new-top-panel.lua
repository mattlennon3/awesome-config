local new_top_panel = {}
local lookup_icon = require("menubar.utils").lookup_icon
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")


new_top_panel.create = function (screen)
    print("top panel not implemented")

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


    awful.popup {
        widget = app_launcher('firefox'),
        bg = beautiful.transparent,
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
        hide_on_right_click = true,
    }


    -- local panel = awful.wibar({
    --     screen = screen,
    --     position = 'top',
    --     height = beautiful.top_panel_height,
    --     bg = beautiful.bg_normal
    -- })

    -- panel:setup {
    --     {app_launcher("minecraft-launcher")}
    -- }

end

return new_top_panel
