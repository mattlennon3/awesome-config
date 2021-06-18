-- ===================================================================
-- CPU Meter
-- ===================================================================
local awful = require("awful")


-- sensors | grep -ioP "Tctl:\s+\+\K(.*)"
-- To use pipe (|) in commands, must be wrapped in bash -c first.
local cpu_temp = awful.widget.watch('bash -c \'sensors | grep -ioP "Tctl:\\s+\\+\\K(.*)"\'', 5, function (widget, stdout)
    -- TODO: Nice icon
    widget:set_text(" " .. stdout)
end)

return cpu_temp
