local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local taglist = function (s, b)

    local tags = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = b,
	}

	local taglist_wrapped = wibox.widget {
		{

			{
				tags,
				left = dpi(0),
				right = dpi(0),
				top = dpi(0),
				bottom = dpi(0),
				widget = wibox.container.margin
			},
			bg = beautiful.button_bg,
			shape = beautiful.panel_button_shape,
			border_width = beautiful.button_border_width,
			border_color = beautiful.button_border,
			widget = wibox.container.background
		},
		margins = dpi(0),
		widget = wibox.container.margin
    }


	return taglist_wrapped
end

return taglist
