local awful = require("awful")

-- Import logger
local logger = require("log")

-- set this in your .Xresources or .xprofile etc
local device = os.getenv("ML_DEVICE")


-- defaults
local config = {
    wallpaper_dir = "", -- TODO defaultpath
    wallpaper_command = ""
}

if device == "desktop" then
    config.device_name = "desktop"
    config.wallpaper_dir = ""
    config.screenshot_dir = ""
end


awful.spawn.easy_async_with_shell("echo $HOME", function(home_directory)
    if(home_directory) then
        -- TODO: Logs twice because this file is imported in 2 places. Fixme
        logger.log("home directory found: " .. home_directory)
        config.home_dir = string.gsub(home_directory, "\n", "")
    else
        logger.log("home directory not found!!!")
    end
end)

return config
