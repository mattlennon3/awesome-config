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

local device = os.getenv("ML_DEVICE")

-- All rules properties can be functions
-- https://old.reddit.com/r/awesomewm/comments/73ms0f/tag_rule_conditioned_on_the_number_of_screens/dnw03l1/

-- Potential future plan
-- All clients open on the center screen only. Unless specified otherwise


-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
    return {
      -- ===================================================================
      -- All clients will match this rule.
      -- ===================================================================
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
      -- ===================================================================
      -- Floating clients
      -- ===================================================================
       {
          rule_any = {
             instance = {
                "minecraft-launcher"
             },
             name = {
                -- steam stuff
                "Steam Guard - Computer Authorization Required",
                "Friends List",
                "Steam - News",          -- a "temporary" workaround
                "Steam - News (1 of 2)", -- a "temporary" workaround
                "Steam - News (1 of 3)", -- a "temporary" workaround
                "Steam - News (1 of 4)", -- a "temporary" workaround
                "Steam - News (1 of 5)", -- a "temporary" workaround
                "Steam - News (1 of 6)", -- a "temporary" workaround

                -- TS3
                "TeamSpeak 3",

                -- Battle net
                "Blizzard Battle.net",

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                "Event Tester",  -- xev.
             },
             class = {
                "Arandr",
                "Blueman-manager",
                "MessageWin",  -- kalarm.
                "battle.net.exe",
                "Lutris",
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
       -- ===================================================================
       -- Fullscreen clients
       -- ===================================================================
       {
          rule_any = {
             class = {
                "wowclassic.exe",
                "FallGuys_client",
                "rocketleague.exe",
                nil
             },
             name = {
               "Spelunky 2"
            }
          }, properties = {fullscreen = true}
       },
       -- ===================================================================
       -- "Switch to tag"
       -- These clients make you switch to their tag when they appear
       -- ===================================================================
       {
          rule_any = {
            instance = {
               (device == "desktop" and "code" or nil)
            },
            class = {
               "Lutris"
            }
          }, properties = {switchtotag = true}
       },
       -- ===================================================================
       -- Pinned Clients
       -- These clients will stay on top of others
       -- ===================================================================
       {
         rule_any = {
           name = {
              "TeamSpeak 3",
            }
         }, properties = {ontop = true}
      },
       -- ===================================================================
       -- Placement rules
       -- ===================================================================
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
       -- Lutris
       {
         rule_any = {
            class = {
               "Lutris"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
       },
      -- Steam
      {
         rule_any = {
            class = {
               "Steam"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- Epic Launcher
      {
         rule_any = {
            class = {
               "epicgameslauncher.exe"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- Rocket League
      {
         rule_any = {
            class = {
               "rocketleague.exe"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- Spelunky 2
      {
         rule_any = {
            name = {
               "Spelunky 2"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- WoW classic
      {
         rule_any = {
            class = {
               "wowclassic.exe"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- Blizz
      {
         rule_any = {
            class = {
               "Blizzard Battle.net"
            }
         }, properties = {tag = "Games", screen = screens.screen_center_primary}
      },
      -- VSCode
      {
         rule_any = {
           instance = {
               "code"
            },
         }, properties = {tag = "Code"}
      },
      -- VSCode (notes) could not get this working :(
      -- {
      --    rule = {
      --      name = {
      --          "foam-diary"
      --       },
      --    }, properties = {tag = "Notes"}
      -- },
      -- Todoist
      {
         rule_any = {
            instance = {
               "todoist"
            },
         }, properties = {tag = "Notes", screen = screens.screen_right_secondary}
      },
      -- Obsidian
      {
         rule_any = {
            class = {
               "obsidian"
            },
         }, properties = {tag = "Notes", screen = screens.screen_right_secondary}
      },
       -- ===================================================================
       -- Misc
       -- ===================================================================

      --  Visualizer
       {
          rule_any = { 
            name = {"^cava$"},
            class = {"cava"},
         },
         properties = {
            skip_taskbar = true,
            tag = "Music", 
            screen = screens.screen_left_vertical
         }
         -- callback = function (c)
         --    decorations.hide(c)
         --    awful.placement.bottom(c)
         -- end
      },
 
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
          properties = {floating = true, ontop = true, width = 1050, height = 560}
       },
    }
 end




return rules
