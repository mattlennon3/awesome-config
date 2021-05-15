--      __          ________  _____  ____  __  __ ______ 
--      /\ \        / /  ____|/ ____|/ __ \|  \/  |  ____|
--     /  \ \  /\  / /| |__  | (___ | |  | | \  / | |__   
--    / /\ \ \/  \/ / |  __|  \___ \| |  | | |\/| |  __|  
--   / ____ \  /\  /  | |____ ____) | |__| | |  | | |____ 
--  /_/    \_\/  \/   |______|_____/ \____/|_|  |_|______|

-- ===================================================================
-- Development aids
-- ===================================================================

require('utils.live-reload').start()
local develop_mode = os.getenv("AWESOME_DEV_MODE")

-- ===================================================================
-- Initialization
-- ===================================================================

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Import logger
local logger = require("utils.log")

-- clear previous startup log
logger.clearlog()

local theme_name = develop_mode == "TRUE" and "new-space" or "default"

logger.log("Using theme: " ..  theme_name)

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/" .. theme_name .. ".lua")

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

-- Import panels
local top_panel = require("components.top-panel")
local new_top_panel = require("components.new-top-panel")


-- Autostart specified apps
local apps = require("apps")
apps.autostart()

-- Screens
local screens = require("screens")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
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

logger.log('Screencount: ' .. screen:count())
logger.separator()
 
 -- Set up each screen (add tags & panels)
awful.screen.connect_for_each_screen(function(awful_screen)
   local screen_name = ''
   local screen_settings = nil

   for k, v in pairs(awful_screen.outputs) do
      screen_name = k
      screen_settings = screens.getSettingsForScreen(k)
   end

   logger.log("Screen name: " .. screen_name)
   logger.log("Screen settings found: " .. (screen_settings and "yes" or "no"))

   for k, tag in pairs(screen_settings.tags) do 
      tag.tag_object = awful.tag.add(tag.name, {
         layout = tag.layout and tag.layout or screen_settings.screen_layout,
         screen = awful_screen,
         selected = tag.selected,
         master_width_factor = tag.master_width_factor or screens.master_width_factor,
         master_fill_policy = tag.local_master_fill_policy or screens.global_master_fill_policy,
         gap_single_client = false
      })
   end

   if develop_mode == "TRUE" then
      new_top_panel.create(awful_screen)
   else
      top_panel.create(awful_screen)
   end

   logger.separator()
end)

-- ===================================================================
-- Events
-- ===================================================================

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
         -- Spotify on comms tag
         if c.class == "Spotify" then
            local vert_screen = screens.getScreenByOutput(screens.screen_left_vertical)
            local comms_tag = awful.tag.find_by_name(vert_screen, "Comms")
            c:toggle_tag(comms_tag)
         end
      end)
      -- CAREFUL - Clients such as spotify change their name regularly (track change), forcing them to reapply rules & jump back to their original tag
      -- c:connect_signal("property::name", function ()
      --    logger.log('Client name added: ' .. (c.name or ' -nil- '))
      --    c.minimized = false
      --    awful.rules.apply(c)
      -- end)
   end

   -- cava ran inside a terminal which sets the name after launching
   if c.name == "Alacritty" then
      local watch_name = function ()
         if c.name == "cava" then
            awful.rules.apply(c)
         end
         -- TODO: Does not work - FIXME
         -- c:disconnect_signal("property::name", self)
      end
      
      c:connect_signal("property::name", watch_name)
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
