local awful = require("awful")

-- get envs
local develop_mode = os.getenv("AWESOME_DEV_MODE")
local home = os.getenv("HOME")

local logger = {}

local log_dir =     home .. "/Logs/awesome/awesome.log"
local log_dev_dir = home .. "/Logs/awesome/awesome_dev.log"
local dir = (develop_mode == "TRUE" and log_dev_dir or log_dir)

-- Log to a file
function logger.log(message)
    local logfile = io.open(dir, "a")
    io.output(logfile)
    io.write(message .. '\n')
    io.close(logfile)
    -- Also print to console
    print(message)
end

function logger.clearlog()
    awful.spawn.with_shell("echo > " .. dir, false)
end


-- old & unsafe
-- function logger.log(message)
--     awful.spawn.with_shell(string.format("echo %s >> " .. dir, message), false)
--     print(message)
-- end

return logger
