-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

local screens = require("screens")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}

-- All rules properties can be functions
-- https://old.reddit.com/r/awesomewm/comments/73ms0f/tag_rule_conditioned_on_the_number_of_screens/dnw03l1/


-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
    return {
       -- All clients will match this rule.
       {
          rule = {},
          properties = {
             border_width = beautiful.border_width,
             border_color = beautiful.border_normal,
             focus = awful.client.focus.filter,
             raise = true,
             keys = clientkeys,
             buttons = clientbuttons,
             screen = awful.screen.preferred,
             placement = awful.placement.centered+awful.placement.no_offscreen
          },
       },
       -- Floating clients.
       {
          rule_any = {
             instance = {
                "minecraft-launcher"
             },
             name = {
                -- steam stuff
                "Steam Guard - Computer Authorization Required",
                "Friends List",

                -- TS3
                "TeamSpeak 3",

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                "Event Tester",  -- xev.
             },
             class = {
                "Arandr",
                "Blueman-manager",
                "MessageWin",  -- kalarm.
             },
             role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",
                "GtkFileChooserDialog"
             },
             type = {
                "dialog"
             }
          }, properties = {floating = true}
       },

       -- Fullscreen clients
       {
          rule_any = {
             class = {
                -- "Terraria.bin.x86",
                "FallGuys_client",
                nil
             },
          }, properties = {fullscreen = true}
       },

       -- "Switch to tag"
       -- These clients make you switch to their tag when they appear
       {
          rule_any = {
            instance = {
                "code"
             },
          }, properties = {tag = "Code", switchtotag = true}
       },

       {
         rule_any = {
            class = {
               "discord"
            }
         }, properties = {tag = "Comms", screen = screens.screen_left_vertical}
       },
       -- Spotify
       {
         rule_any = {
            class = {
               "Spotify"
            }
         }, properties = {tag = "Music", screen = screens.screen_left_vertical}
       },

       -- Visualizer
    --    {
    --       rule_any = {name = {"cava"}},
    --       properties = {
    --          floating = true,
    --          maximized_horizontal = true,
    --          sticky = true,
    --          ontop = false,
    --          skip_taskbar = true,
    --          below = true,
    --          focusable = false,
    --          height = screen_height * 0.40,
    --          opacity = 0.6
    --       },
    --       callback = function (c)
    --          decorations.hide(c)
    --          awful.placement.bottom(c)
    --       end
    --    },
 
       -- Rofi
    --    {
    --       rule_any = {name = {"rofi"}},
    --       properties = {maximized = true, ontop = true}
    --    },
 
       -- File chooser dialog
       {
          rule_any = {role = {"GtkFileChooserDialog"}},
          properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
       },
 
       -- Pavucontrol & Bluetooth Devices
       {
          rule_any = {class = {"Pavucontrol"}, name = {"Bluetooth Devices"}},
          properties = {floating = true, width = 1050, height = 560}
       },
    }
 end




return rules
