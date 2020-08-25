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

-- Import logger
local logger = require("log")
-- clear previous startup log
logger.clearlog()

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")


-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
-- root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Notification library
local naughty = require("naughty")

-- Import notification appearance

-- Import components

-- Import tag settings
local tags = require("tags")

-- Import panels
local top_panel = require("components.top-panel")

-- Autostart specified apps
local apps = require("apps")
apps.autostart()


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- lua util
local function isempty(s)
   return s == nil or s == ''
 end

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

-- Ratio of screen space master client takes
local local_master_width_factor = 0.65
-- Master takes the full screen when it's on it's own
local local_master_fill_policy = "expand"


-- some helpful screen code https://github.com/raphaelfournier/Dotfiles/blob/master/awesome/.config/awesome/rc.lua
-- logger.log( screen:count() )

-- Set up each screen (add tags & panels)
awful.screen.connect_for_each_screen(function(s)

   local screen_name = ''
   for k, v in pairs(s.outputs) do
      screen_name = k
   end

   logger.log('----')
   logger.log("Screen name: " .. screen_name)
   logger.log("Screen index: " .. s.index)

   -- Wallpaper
   set_wallpaper(s)
   logger.log('screencount: ' .. screen:count())
   
   -- if we are on desktop with 3 screens
   if(screen:count() == 3) then
      for i, tag in pairs(tags) do
         -- if I want a tag on a specific screen
         if tag.specific_screen == nil or screen_name == tag.specific_screen then
            
            logger.log(tag.name .. " - " .. (tag.specific_screen or 'nil') .. " - " .. screen_name)
            
            awful.tag.add(tag.name, {
               layout = tag.layout and tag.layout or awful.layout.suit.tile,
               screen = s,
               selected = tag.name == "Web",
               master_width_factor = tag.master_width_factor or local_master_width_factor,
               master_fill_policy = tag.local_master_fill_policy or local_master_fill_policy,
               gap_single_client = false
            })
         end
      end
      
      -- else fall back to just putting every tag on every screen
   else
      for i, tag in pairs(tags) do
         awful.tag.add(tag.name, {
            layout = tag.layout and tag.layout or awful.layout.suit.tile,
            screen = s,
            selected = tag.name == "Web",
            master_width_factor = tag.master_width_factor or local_master_width_factor,
            master_fill_policy = tag.local_master_fill_policy or local_master_fill_policy,
            gap_single_client = false
         })
      end
   end

   top_panel.create(s)

end)

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
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

   -- Attempt to fix spotify tracking. This will start any programs minimized if they have an xprop class of nil 
   -- https://redd.it/d8r74k
    if c.class == nil then
      c.minimized = true
      logger.log('No client class found, attaching watcher...')
      c:connect_signal("property::class", function ()
         logger.log('Client class added: ' .. (c.class or ' -nil- '))
         c.minimized = false
         awful.rules.apply(c)
      end)
   end
 end)


-- ===================================================================
-- Client Focusing
-- ===================================================================

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
