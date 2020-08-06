--      __          ________  _____  ____  __  __ ______ 
--      /\ \        / /  ____|/ ____|/ __ \|  \/  |  ____|
--     /  \ \  /\  / /| |__  | (___ | |  | | \  / | |__   
--    / /\ \ \/  \/ / |  __|  \___ \| |  | | |\/| |  __|  
--   / ____ \  /\  /  | |____ ____) | |__| | |  | | |____ 
--  /_/    \_\/  \/   |______|_____/ \____/|_|  |_|______|


-- ===================================================================
-- Initialization
-- ===================================================================

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")


-- Import Keybinds

-- Import rules

-- Import notification appearance

-- Import components

-- Import tag settings
local tags = require("tags")

-- Import panels
local top_panel = require("components.top-panel")

-- Autostart specified apps

-- ===================================================================
-- Set wallpaper
-- ===================================================================

local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
       local wallpaper = beautiful.wallpaper
       -- If wallpaper is a function, call it with the screen
       if type(wallpaper) == "function" then
           wallpaper = wallpaper(s)
       end
       gears.wallpaper.maximized(wallpaper, s, true)
   end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- ===================================================================
-- Set Up Screen & Connect Signals
-- ===================================================================

-- Define tag layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
 }


-- Set up each screen (add tags & panels)
awful.screen.connect_for_each_screen(function(s)

   -- Wallpaper
   set_wallpaper(s)

   for i, tag in pairs(tags) do
      awful.tag.add(tag.name, {
         layout = tag.layout and tag.layout or awful.layout.suit.tile,
         screen = s,
         selected = i == 1
      })
   end

   top_panel.create(s)

end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the window as a slave (put it at the end of others instead of setting it as master)
    if not awesome.startup then
       awful.client.setslave(c)
    end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
       -- Prevent clients from being unreachable after screen count changes.
       awful.placement.no_offscreen(c)
    end
 end)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)