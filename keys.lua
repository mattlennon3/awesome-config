-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local hotkeys_popup = require("awful.hotkeys_popup")

-- Default Applications
local apps = require("apps").default

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


-- define module table
local keys = {}

-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================



-- ===================================================================
-- Mouse bindings
-- ===================================================================

keys.clientbuttons = gears.table.join(
    -- Enable click to focus
    awful.button({ }, leftclick, function (c)
        print('clicked me')
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
    awful.key({modkey}, "Return",
        function()
            awful.spawn(apps.terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    -- Spawn launcher
    awful.key({modkey}, "r",
        function()
        awful.spawn(apps.launcher)
        end,
        {description = "application launcher", group = "launcher"}
    ),
    -- Spawn file explorer
    awful.key({modkey}, "e",
        function()
        awful.spawn(apps.filebrowser)
        end,
        {description = "file explorer", group = "launcher"}
    ),

    -- Show help popup
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
        {description="show help", group="awesome"}),



   -- =========================================
   -- FUNCTION KEYS
   -- =========================================

   -- Brightness
   awful.key({}, "XF86MonBrightnessUp",
      function()
         awful.spawn("xbacklight -inc 10", false)
      end,
      {description = "+10%", group = "hotkeys"}
   ),
   awful.key({}, "XF86MonBrightnessDown",
      function()
         awful.spawn("xbacklight -dec 10", false)
      end,
      {description = "-10%", group = "hotkeys"}
   ),

   -- ALSA volume control
   awful.key({}, "XF86AudioRaiseVolume",
      function()
         awful.spawn("amixer -D pulse sset Master 5%+", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn("amixer -D pulse sset Master 5%-", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume down", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioMute",
      function()
         awful.spawn("amixer -D pulse set Master 1+ toggle", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "toggle mute", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioNext",
      function()
         awful.spawn("mpc next", false)
      end,
      {description = "next music", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioPrev",
      function()
         awful.spawn("mpc prev", false)
      end,
      {description = "previous music", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioPlay",
      function()
         awful.spawn("mpc toggle", false)
      end,
      {description = "play/pause music", group = "hotkeys"}
   ),

   -- Screenshot on prtscn using scrot
   awful.key({}, "Print",
      function()
         awful.util.spawn(apps.screenshot, false)
      end
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
      {description = "toggle exit screen", group = "hotkeys"}
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

   -- =========================================
   -- CLIENT RESIZING
   -- =========================================

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- =========================================
   -- GAP CONTROL
   -- =========================================

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
   awful.key({modkey, "Shift"}, "space",
      function()
         awful.layout.inc(-1)
      end,
      {description = "select previous", group = "layout"}
   ),

   -- =========================================
   -- CLIENT MINIMIZATION
   -- =========================================

   -- restore minimized client
   awful.key({modkey, "Shift"}, "n",
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
          c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
       elseif direction == "down" then
          c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
       elseif direction == "left" then
          c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
       elseif direction == "right" then
          c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
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
   awful.key({modkey, "Shift"}, "Down",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "Up",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "Left",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "Right",
      function(c)
         move_client(c, "right")
      end
   ),
   awful.key({modkey, "Shift"}, "j",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "k",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "h",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "l",
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

   -- close client
   awful.key({modkey, shiftkey}, "c",
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
-- TAG BINDINGS
-- =========================================

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
       awful.key({modkey, "Shift"}, "#" .. i + 9,
          function()
             if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                   client.focus:move_to_tag(tag)
                end
             end
          end,
          {description = "move focused client to tag #"..i, group = "tag"}
       )
    )
 end

return keys
