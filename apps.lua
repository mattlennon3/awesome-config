-- ===================================================================
-- Initialization
-- =========================================

local awful = require("awful")
local filesystem = require("gears.filesystem")

-- define module table
local apps = {}

local device = os.getenv("ML_DEVICE")

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
    -- TODO write a PKGBUILD for this repo? 
    -- define programs used in here for now at least
    x_helpers = {
        xdotool = "xdotool",
        xclip = "xclip"
    },
    altTab = "rofi -show window",
    -- calculator | control + numpad0 to open (requires rofi-calc package). control + c to copy result
    calculator = "rofi -show calc -modi calc -no-show-match -no-sort -kb-accept-custom 'Control_L+c' -calc-command 'echo {result}' | xclip -selection clipboard",
    webbrowser = (device == "desktop" and "firefox-developer-edition" or "firefox"),
    rofiTimer = "$HOME/git/rust/rofi-timer/target/release/rofi-timer"
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
