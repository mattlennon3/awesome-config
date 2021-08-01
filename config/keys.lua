-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
-- local dpi = beautiful.xresources.apply_dpi
local hotkeys_popup = require("awful.hotkeys_popup")

-- Alt-tab library
-- local cyclefocus = require('cyclefocus')

-- Import logger
local logger = require("utils.log")

-- Default Applications
local apps = require("config.apps").default

-- Icons
local icon_paths = require("themes.icons").icon_paths

-- Screens
local screens = require("config.screens")

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"
local ctrlkey = "Control"
local shiftkey = "Shift"

-- Define mouse buttons
local leftclick = 1
local rightclick = 3
local scrollup = 4
local scrolldown = 5

local XF86Binds = {
   -- Brightness (laptop)
   brightnessUp = "XF86MonBrightnessUp",
   brightnessDown = "XF86MonBrightnessDown",
   -- Audio Control
   audioRaiseVolume = "XF86AudioRaiseVolume",
   audioLowerVolume = "XF86AudioLowerVolume",
   audioMute = "XF86AudioMute",
   audioNext = "XF86AudioNext",
   audioPrev = "XF86AudioPrev",
   audioPlay = "XF86AudioPlay",
   -- Macro keypad (bind spare XF86 keys to functions)
   macro1 = "XF86Launch1",
   macro2 = "XF86Launch2",
   macro3 = "XF86Launch3",
   macro4 = "XF86Launch4",
}

-- define module table
local keys = {}

local spotlight_source_screen = nil
local spotlight_source_tag = nil
local spotlight_client = nil

-- Get home dir
local home_dir = os.getenv("HOME")

local getScreenshotBaseDir = function (subdir)
   if(subdir) then
      return home_dir .. "/Content/Screenshots/" .. subdir .. "/"
   end
   return home_dir .. "/Content/Screenshots/"
end

local generateScreenshotFileName = function (client_name)
   local prefix = "Screenshot-"
   if client_name then
      -- remove spaces and /slashes/
      prefix = string.gsub(client_name, "(%s+)", "")
      prefix = string.gsub(prefix, "(/+)", "") .. "-"
   end
   return prefix .. os.date("%Y-%m-%d_%Hh%Mm%Ss") .. ".png"
end

-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================



-- ===================================================================
-- Mouse bindings
-- ===================================================================

keys.clientbuttons = gears.table.join(
    -- Enable click to focus
    awful.button({ }, leftclick, function (c)
         -- c:emit_signal("request::activate", "mouse_click", {raise = true})
         client.focus = c
         c:raise()
    end),
    -- Enable mod + click to move
    awful.button({ modkey }, leftclick, function (c)
         -- c:emit_signal("request::activate", "mouse_click", {raise = true})
         awful.mouse.client.move(c)
    end),
    -- Enable mod + click to resize
    awful.button({ modkey }, rightclick, function (c)
         -- c:emit_signal("request::activate", "mouse_click", {raise = true})
         awful.mouse.client.resize(c)
    end)
)


-- TODO: Figure out how to bind these to the titlebar only (scroll to change tags)
-- awful.button({ }, 3, function () mymainmenu:toggle() end),
-- awful.button({ }, scrollup, awful.tag.viewnext),
-- awful.button({ }, scrolldown, awful.tag.viewprev)

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================


keys.globalkeys = gears.table.join(
    -- =========================================
    -- SPAWN APPLICATION KEY BINDINGS
    -- =========================================
    -- Spawn terminal
    awful.key({ modkey }, "Return",
        function()
            awful.spawn(apps.terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    -- Spawn launcher
    awful.key({ modkey }, "r",
        function()
        awful.spawn(apps.launcher)
        end,
        {description = "application launcher", group = "launcher"}
    ),
    -- Spawn task manager
    awful.key({ ctrlkey, shiftkey }, "Escape",
        function()
        awful.spawn(apps.task_manager)
        end,
        {description = "task manager", group = "launcher"}
    ),
    -- Spawn file explorer
    awful.key({ modkey }, "e",
        function()
        awful.spawn(apps.filebrowser)
        end,
        {description = "file explorer", group = "launcher"}
    ),
    -- Spawn web browser
    awful.key({ modkey }, "w",
        function()
        awful.spawn(apps.webbrowser)
        end,
        {description = "web browser", group = "launcher"}
    ),
    -- Spawn web browser private window
    awful.key({ modkey, shiftkey }, "w",
        function()
        awful.spawn(apps.webbrowser .. " --private-window")
        end,
        {description = "web browser, private window", group = "launcher"}
    ),
    -- Spawn brave browser
    awful.key({ modkey }, "d",
        function()
        awful.spawn(apps.bravebrowser)
        end,
        {description = "web browser", group = "launcher"}
    ),
    -- Spawn brave browser private window
    awful.key({ modkey, shiftkey }, "d",
        function()
        awful.spawn(apps.bravebrowser .. " --incognito")
        end,
        {description = "web browser, private window", group = "launcher"}
    ),
    -- Show help popup
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    -- Lock screen
    awful.key({ modkey }, "l",
         function()
            awful.spawn(apps.lock)
         end,
        {description="lock screen", group="awesome"}),


   -- =========================================
   -- FUNCTION KEYS
   -- =========================================

   -- Brightness
   awful.key({}, XF86Binds.brightnessUp,
      function()
         awful.spawn("xbacklight -inc 10", false)
      end,
      {description = "+10%", group = "hotkeys"}
   ),
   awful.key({}, XF86Binds.brightnessDown,
      function()
         awful.spawn("xbacklight -dec 10", false)
      end,
      {description = "-10%", group = "hotkeys"}
   ),

   -- ALSA volume control
   awful.key({}, XF86Binds.audioRaiseVolume,
      function()
         awful.spawn("amixer -D pulse sset Master 5%+", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "hotkeys"}
   ),
   awful.key({}, XF86Binds.audioLowerVolume,
      function()
         awful.spawn("amixer -D pulse sset Master 5%-", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume down", group = "hotkeys"}
   ),
   awful.key({}, XF86Binds.audioMute,
      function()
         awful.spawn("amixer -D pulse set Master 1+ toggle", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "toggle mute", group = "hotkeys"}
   ),
   -- https://wiki.archlinux.org/index.php/MPRIS
   awful.key({}, XF86Binds.audioNext,
      function()
         awful.spawn(apps.mediaKeys .. " next", false)
      end,
      {description = "next music", group = "hotkeys"}
   ),
   awful.key({}, XF86Binds.audioPrev,
      function()
         awful.spawn(apps.mediaKeys .. " previous", false)
      end,
      {description = "previous music", group = "hotkeys"}
   ),
   awful.key({}, XF86Binds.audioPlay,
      function()
         awful.spawn(apps.mediaKeys .. " play-pause", false)
      end,
      {description = "play/pause music", group = "hotkeys"}
   ),

   -- Screenshot current active client
   awful.key({}, "Print",
      function()
         -- Get class of window to make a directory for it
         local class = client.focus.class
         class = string.gsub(client.focus.class, "%s+", "-")
         if class == "" then
            class = "Unknown"
         end
         local screenshotDir = getScreenshotBaseDir(class)
         -- Do getactivewindow first, incase we're tabbing out or other shenanigans
         awful.spawn.easy_async_with_shell(apps.x_helpers.xdotool .. " getactivewindow > /tmp/awesome-active-client.txt", function()
            awful.spawn.easy_async_with_shell("mkdir -p " .. screenshotDir, function()
               awful.spawn.easy_async_with_shell("cat /tmp/awesome-active-client.txt", function(client_id_string)
                  if(client_id_string) then
                     local client_id = string.gsub(client_id_string, "\n", "")
                     local file_name = screenshotDir .. generateScreenshotFileName(client.focus.name)
                     local command = (apps.screenshot .. " -i " .. client_id .. " " .. file_name)
                     
                     logger.log("Screenshot: " .. command)
                     awful.spawn.easy_async_with_shell(command, function() end)
                  end
               end)
            end)
         end)
      end,
      {description = "screenshot current client", group = "hotkeys"}
   ),

   -- Screenshot area
   awful.key({modkey, shiftkey}, "s",
      -- for snipping tool screenshot in windows:
      -- windows key + shift + s
      function()
         local screenshotDir = getScreenshotBaseDir("SnippingTool")
         awful.spawn.easy_async_with_shell("mkdir -p " .. screenshotDir, function()
            local file_name = screenshotDir .. generateScreenshotFileName()
            local command = (apps.screenshot .. " -s " .. file_name)

            logger.log("Screenshot area snip: " .. command)
            awful.spawn.easy_async_with_shell(command, function() 
               -- copy to clipboard
               awful.spawn.easy_async_with_shell(apps.x_helpers.xclip .. " -selection clipboard -t image/png -i " .. file_name)
            end)
         end)
      end,
      {description = "screenshot selection area", group = "hotkeys"}
   ),

   -- Screenshot whole desktop
   awful.key({altkey}, "Print",
      function()
         local screenshotDir = getScreenshotBaseDir("Desktop")
         awful.spawn.easy_async_with_shell("mkdir -p " .. screenshotDir, function()
            local file_name = screenshotDir .. generateScreenshotFileName()
            local command = (apps.screenshot .. " " .. file_name)

            logger.log("Screenshot: " .. command)
            awful.spawn.easy_async_with_shell(command, function() end)
         end)
      end,
      {description = "screenshot whole desktop", group = "hotkeys"}
   ),

   -- =========================================
   -- PROGRAM LAUNCHERS
   -- =========================================

   awful.key({modkey}, "#90", -- num pad 0
      function ()
         awful.spawn.easy_async_with_shell(apps.calculator, function() end)
      end,
      {description = "calculator", group = "launcher"}
   ),

   awful.key({modkey}, "t",
      function ()
         awful.spawn.easy_async_with_shell(apps.rofiTimer, function() end)
      end,
      {description = "timer", group = "launcher"}
   ),

   awful.key({modkey, shiftkey}, "p",
      function ()
         awful.spawn.easy_async_with_shell(apps.password_prompt, function() end)
      end,
      {description = "timer", group = "launcher"}
   ),

   awful.key({modkey}, "y",
      function ()
         awful.spawn.easy_async_with_shell(apps.youtube_dl_rofi_prompt, function() end)
      end,
      {description = "timer", group = "launcher"}
   ),

   -- =========================================
   -- MACRO KEYPAD SHORTCUTS
   -- =========================================

   -- awful.key({}, XF86Binds.macro1,
   --    function ()

   --    end,
   --    {description = "macro key 1", group = "launcher"}
   -- ),

   awful.key({}, XF86Binds.macro2,
      function ()

         -- Error log:
            -- Spotlight tag exists, not focused, no client inside. Can't send any new clients to spotlight from any screen.
            -- Can focus and unfocus the spotlight tag but it doesn't close itself.
            -- had to move a client onto the tag, and remove it so the spotlight tag closed itself. Then things worked as normal again.
         
         -- Get the main screen
         local main_screen = screens.getScreenByOutput(screens.screen_center_primary.output)
         
         -- bail for laptop etc
         if main_screen == nil then -- TODO: Just check for ML_DEVICE?
            return
         end

         local spotlight_tag = awful.tag.find_by_name(main_screen, "Spotlight")

         local addSpotlightTag = function()
            awful.tag.add("Spotlight", {
               layout = awful.layout.suit.tile,
               screen = main_screen,
               selected = true,
               volatile = true,
               gap_single_client = false
            })

            spotlight_tag = awful.tag.find_by_name(main_screen, "Spotlight")
         end

         local addClientToSpotlight = function(c)
            -- save info before moving client
            spotlight_client = c
            spotlight_source_screen = spotlight_client.screen
            spotlight_source_tag = spotlight_source_screen.selected_tag
            -- move client to spotlight tag
            spotlight_client:move_to_tag(main_screen.tags[spotlight_tag.index])
            spotlight_client.fullscreen = true
            -- focus spotlight
            spotlight_client:raise()
         end

         local restoreClient = function()
            -- TODO use clients previous fullscreen value rather than just false
            spotlight_client.fullscreen = false
            spotlight_client:move_to_tag(spotlight_source_screen.tags[spotlight_source_tag.index])
         end
       
         -- if no spotlight tag exists
         if spotlight_tag == nil then
            addSpotlightTag()
            addClientToSpotlight(client.focus)
            
         -- spotlight tag exists, restore client to where it came from, swap focused client in
         -- bit ugly to use name rather than ID, but was the closest thing
         elseif spotlight_client.name ~= client.focus.name then
            -- get new spotlight client
            local next_spotlight_client = client.focus
            -- return existing client back to where it came from
            restoreClient()
            -- Spotlight tag is probably destroyed at this point as it is volatile
            addSpotlightTag()
            -- move new client into spotlight
            addClientToSpotlight(next_spotlight_client)
            
            -- spotlight tag exists and we have triggered this on the spotlight client, return client to where it came from
         elseif spotlight_client ~= nil then
            -- return spotlight client back to where it came from
            restoreClient()
            -- focus it
            spotlight_client:raise()
            -- cleanup
            spotlight_client = nil
            spotlight_source_screen = nil
            spotlight_source_tag = nil
         else
            -- incase of weirdness. Should not happen
            awful.spawn.easy_async_with_shell("notify-send 'spotlight bug'", function() end)
            logger.log("SPOTLIGHT - DELETE EDGE CASE")
            logger.log("client.focus.name: " .. client.focus.name)
         end
      end,
      {description = "macro key 2 - spotlight", group = "launcher"}
   ),

   awful.key({}, XF86Binds.macro3,
      function ()
         awful.spawn.easy_async_with_shell(apps.scripts.keyboardToggle, function(state) 
         local side_screen = screens.getScreenByOutput(screens.screen_right_secondary.output)
         for line in state:gmatch("[^\r\n]+") do
            if line == "guest" then
               naughty.notify({
                  title = "Attaching devices to guest",
                  screen = side_screen,
                  icon = icon_paths.windows10,
                  timeout = 1,
                  position = "top_left"
               })
               awesome.emit_signal("kb_state_change", line)
            elseif line == "host" then
               naughty.notify({
                  title = "Attaching devices to host",
                  screen = side_screen,
                  icon = icon_paths.linux,
                  timeout = 1,
                  position = "top_left"
               })
               awesome.emit_signal("kb_state_change", line)
            end
         end
         end)
      end,
      {description = "macro key 3 - keyboard toggle", group = "launcher"}
   ),

   awful.key({}, XF86Binds.macro4,
      function ()
         -- Teamspeak Mute
         local old_coords = mouse.coords()
         mouse.coords {
            x = 812,
            y = 1340
         }
         awful.spawn.easy_async_with_shell(apps.x_helpers.xdotool .. " click 1", function()
            mouse.coords {
               x = old_coords.x,
               y = old_coords.y
            }         
         end)
      end,
      {description = "macro key 4", group = "launcher"}
   ),

   -- =========================================
   -- RELOAD / QUIT AWESOME
   -- =========================================

   -- Reload Awesome
   awful.key({modkey, ctrlkey}, "r",
      awesome.restart,
      {description = "reload awesome", group = "awesome"}
   ),
   -- Quit Awesome
   awful.key({modkey, shiftkey}, "Escape",
      awesome.quit,
      {description = "toggle exit screen", group = "awesome"}
   ),

--    awful.key({}, "XF86PowerOff",
--       function()
--           -- emit signal to show the exit screen
--           awesome.emit_signal("show_exit_screen")
--       end,
--       {description = "toggle exit screen", group = "hotkeys"}
--    ),

   -- =========================================
   -- CLIENT FOCUSING
   -- =========================================

   awful.key({ modkey }, "u",
      awful.client.urgent.jumpto,
   {description = "jump to urgent client", group = "client"}),

   awful.key({altkey}, "Tab",
   -- Holding ALT when pressing tab repeatedly will just keep
   -- opening the same rofi dialog,
   -- rather than cycling the list of items in rofi
   -- FIX: do not spawn the command if the rofi dialog box is open
      function ()
         awful.spawn.easy_async_with_shell(apps.altTab, function() end)
      end,
   {description = "Open alt-tab prompt", group = "client"}),

   -- =========================================
   -- CLIENT RESIZING
   -- =========================================

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- =========================================
   -- GAP CONTROL
   -- =========================================

   awful.key({modkey}, "-",
      function()
         awful.tag.incgap(5, nil)
      end,
      {description = "increment gaps size for the current tag", group = "gaps"}
   ),
   awful.key({modkey, shiftkey}, "=",
      function()
         awful.tag.incgap(-5, nil)
      end,
      {description = "decrement gap size for the current tag", group = "gaps"}
   ),

   -- =========================================
   -- LAYOUT SELECTION
   -- =========================================

   -- select next layout
   awful.key({modkey}, "space",
      function()
         awful.layout.inc(1)
      end,
      {description = "select next", group = "layout"}
   ),
   -- select previous layout
   awful.key({modkey, shiftkey}, "space",
      function()
         awful.layout.inc(-1)
      end,
      {description = "select previous", group = "layout"}
   ),

   -- =========================================
   -- CLIENT MINIMIZATION
   -- =========================================

   -- restore minimized client
   awful.key({modkey, shiftkey}, "n",
      function()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}
   )
)



-- ===================================================================
-- Client Key bindings
-- ===================================================================

-- Move given client to given direction
local function move_client(c, direction)
    -- If client is floating, move to edge
    if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
       local workarea = awful.screen.focused().workarea
       if direction == "up" then
          c:geometry({nil, y = workarea.y + beautiful.useless_gap * 4, nil, nil})
       elseif direction == "down" then
          c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 4 - beautiful.border_width * 2, nil, nil})
       elseif direction == "left" then
          c:geometry({x = workarea.x + beautiful.useless_gap * 4, nil, nil, nil})
       elseif direction == "right" then
          c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 4 - beautiful.border_width * 2, nil, nil, nil})
       end
    -- Otherwise swap the client in the tiled layout
    elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
       if direction == "up" or direction == "left" then
          awful.client.swap.byidx(-1, c)
       elseif direction == "down" or direction == "right" then
          awful.client.swap.byidx(1, c)
       end
    else
       awful.client.swap.bydirection(direction, c, nil)
    end
 end

keys.clientkeys = gears.table.join(
    -- Move to edge or swap by direction
   awful.key({modkey, shiftkey}, "Down",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, shiftkey}, "Up",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, shiftkey}, "Left",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, shiftkey}, "Right",
      function(c)
         move_client(c, "right")
      end
   ),
   awful.key({modkey, shiftkey}, "j",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, shiftkey}, "k",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, shiftkey}, "h",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, shiftkey}, "l",
      function(c)
         move_client(c, "right")
      end
   ),

   -- toggle fullscreen
   awful.key({modkey}, "f",
      function(c)
         c.fullscreen = not c.fullscreen
      end,
      {description = "toggle fullscreen", group = "client"}
   ),

   -- toggle pinned
   awful.key({modkey}, "p",
      function (c)
         c.ontop = not c.ontop
      end,
      {description = "toggle keep on top", group = "client"}
   ),

   -- toggle floating
   awful.key({ modkey, ctrlkey }, "space",
      awful.client.floating.toggle,
      {description = "toggle floating", group = "client"}),

   -- close client
   awful.key({modkey, shiftkey}, "c",
      function(c)
         c:kill()
      end,
      {description = "close", group = "client"}
   ),

   -- close client 2
   awful.key({modkey}, "q",
      function(c)
         c:kill()
      end,
      {description = "close", group = "client"}
   ),

   -- Minimize
   awful.key({modkey}, "n",
      function(c)
         c.minimized = true
      end,
      {description = "minimize", group = "client"}
   ),

   -- Maximize
   awful.key({modkey}, "m",
      function(c)
         c.maximized = not c.maximized
         c:raise()
      end,
      {description = "(un)maximize", group = "client"}
   )
)


-- =========================================
-- TASK BINDINGS
-- =========================================

keys.tasklist_buttons = gears.table.join(
   awful.button({ }, leftclick, function (c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal(
            "request::activate",
            "tasklist",
            {raise = true}
         )
      end
   end),
   awful.button({ }, rightclick, function()
         awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({ }, scrollup, function ()
         awful.client.focus.byidx(1)
   end),
   awful.button({ }, scrolldown, function ()
         awful.client.focus.byidx(-1)
   end
   )
)


-- =========================================
-- TAG KEYBOARD BINDINGS
-- =========================================

-- Keyboard mod + 1-9
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
       -- Switch to tag
       awful.key({modkey}, "#" .. i + 9,
          function()
             local screen = awful.screen.focused()
             local tag = screen.tags[i]
             if tag then
                tag:view_only()
             end
          end,
          {description = "view tag #"..i, group = "tag"}
       ),
       -- Move client to tag
       awful.key({modkey, shiftkey}, "#" .. i + 9,
          function()
             if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                   client.focus:move_to_tag(tag)
                end
             end
          end,
          {description = "move focused client to tag #"..i, group = "tag"}
       ),
       -- Toggle tag on focused client.
       awful.key({ modkey, ctrlkey, shiftkey }, "#" .. i + 9,
         function ()
            if client.focus then
                  local tag = client.focus.screen.tags[i]
                  if tag then
                     client.focus:toggle_tag(tag)
                  end
            end
         end,
         {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
 end

-- =========================================
-- TAG MOUSE BINDINGS
-- =========================================

keys.taglist_buttons = gears.table.join(
      -- View tag
      awful.button({ }, leftclick, function(t) t:view_only() end),
      -- View tag & send current client to the tag with you
      awful.button({ modkey }, leftclick, function(t)
                                 if client.focus then
                                    client.focus:move_to_tag(t)
                                 end
                           end),
      -- Focus this tag also (merges clients)
      awful.button({ }, rightclick, awful.tag.viewtoggle),
      -- Also show client on the tag you clicked
      awful.button({ modkey }, rightclick, function(t)
                                 if client.focus then
                                    client.focus:toggle_tag(t)
                                 end
                           end),
      -- Scroll next tag
      awful.button({ }, scrollup, function(t) awful.tag.viewnext(t.screen) end),
      -- Scroll previous tag
      awful.button({ }, scrolldown, function(t) awful.tag.viewprev(t.screen) end)
   )

return keys
