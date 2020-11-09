-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local filesystem = require("gears.filesystem")

-- define module table
local apps = {}


-- ===================================================================
-- App Declarations
-- ===================================================================


-- define default apps
apps.default = {
    terminal = "alacritty",
    launcher = "dmenu_run",
    lock = "xsecurelock",
    screenshot = "maim",
    filebrowser = "thunar",
    webbrowser = "firefox-developer-edition",
    altTab = "rofi -show window"
}

-- ===================================================================
-- Start up
-- ===================================================================

local device = os.getenv("ML_DEVICE")

-- List of apps to start once on start-up
local run_on_start_up = {
    "code-oss $HOME/git/foam-diary",
}

if device == "desktop" then
    -- table.insert(run_on_start_up, "discord")
    table.insert(run_on_start_up, "spotify")
end

-- Run all the apps listed in run_on_start_up
function apps.autostart()
    for _, app in ipairs(run_on_start_up) do
        local findme = app
        local firstspace = app:find(" ")
        if firstspace then
            findme = app:sub(0, firstspace - 1)
        end
        awful.spawn.easy_async_with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, app), function() end)
    end
end

return apps
