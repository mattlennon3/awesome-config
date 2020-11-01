local awful = require("awful")
local logger = {}

-- Log to a file
function logger.log(message)
    awful.spawn.with_shell(string.format("echo %s >> $HOME/Logs/awesome/awesome.log", message), false)
    print(message)
end

function logger.clearlog()
    awful.spawn.with_shell("echo > $HOME/Logs/awesome/awesome.log", false)
end

return logger
