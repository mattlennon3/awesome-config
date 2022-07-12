-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- Import logger
local logger = require("utils.log")

local screens = require("config.screens")

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

-- Alias screens
local screen_center_primary = screens.screen_center_primary.output
local screen_right_vertical = screens.screen_right_vertical.output


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
                
                "Android Emulator -"
             },
             class = {
                "Arandr",
                "Blueman-manager",
                "MessageWin",  -- kalarm.
                "battle.net.exe",
                "Lutris",
                "pick-colour-picker",
                "gpick",
                "gnome-disks"
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
              "Android Emulator -"
            },
            class = {
               "Xephyr",
               "pick-colour-picker"
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
         }, properties = {tag = "Comms", screen = screen_right_vertical}
       },
       {
         rule_any = {
            name = {
               "TeamSpeak 3"
            },
         }, properties = {
            tag = "Comms",
            screen = screen_right_vertical,
            callback = function (c)
               logger.log("Setting TS3 Location")
               -- Ideal spot, found using xprop
               c.x = 726
               c.y = 1308
               c.height = 527
               c.width = 342
            end
         }
       },
       -- Spotify
       {
         rule_any = {
            class = {
               "Spotify"
            }
         }, properties = {
            tag = "Music", 
            screen = screen_right_vertical,
            callback = function (c)
               logger.log("Spotify on many tags")
               awful.client.setmaster(c)
               local vert_screen = screens.getScreenByOutput(screen_right_vertical)
               local comms_tag = awful.tag.find_by_name(vert_screen, "Comms")
               local prod_tag = awful.tag.find_by_name(vert_screen, "Prod")
               c:toggle_tag(comms_tag)
               c:toggle_tag(prod_tag)
            end
         }
       },
       -- Lutris
       {
         rule_any = {
            class = {
               "Lutris"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
       },
      -- Steam
      {
         rule_any = {
            class = {
               "Steam"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- Epic Launcher
      {
         rule_any = {
            class = {
               "epicgameslauncher.exe"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- Rocket League
      {
         rule_any = {
            class = {
               "rocketleague.exe"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- Spelunky 2
      {
         rule_any = {
            name = {
               "Spelunky 2"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- WoW classic
      {
         rule_any = {
            class = {
               "wowclassic.exe"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- Blizz
      {
         rule_any = {
            class = {
               "Blizzard Battle.net"
            }
         }, properties = {tag = "Games", screen = screen_center_primary}
      },
      -- VSCode
      {
         rule_any = {
           instance = {
               "code"
            },
         }, properties = {tag = "Code"}
      },
      -- Todoist
      {
         rule_any = {
            instance = {
               "todoist"
            },
         }, properties = {
            tag = "Notes", 
            screen = screen_right_vertical,
            callback = function (c)
               awful.client.setmaster(c)
            end
         }
      },
      -- Obsidian
      {
         rule_any = {
            class = {
               "obsidian"
            },
         }, properties = {tag = "Notes", screen = screen_right_vertical}
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
            screen = screen_right_vertical
         }
         -- callback = function (c)
         --    decorations.hide(c)
         --    awful.placement.bottom(c)
         -- end
      },
      -- Pavucontrol
      {
         rule_any = {
            class = {
               "pavucontrol"
            },
            name = {
               "Volume Control"
            }
         }, properties = {tag = "Sound", screen = screen_right_vertical}
      },
      -- Pulseeffects
      {
         rule_any = {
            class = {
               "pulseeffects"
            },
            name = {
               "PulseEffects"
            }
         }, properties = {tag = "Sound", screen = screen_right_vertical}
      },

      -- Firefox
      {
         rule_any = {
            class = {
               "firefoxdeveloperedition"
            }
         }, properties = {
            callback = function (c)
               -- not used atm
            end
         }
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
