-- ===================================================================
-- Imports
-- ===================================================================

local awful = require("awful")

-- ===================================================================
-- Definitions
-- ===================================================================

local screens = {}

-- circular reference problem???
screens.global_master_width_factor = 0.65
screens.global_layout = awful.layout.suit.tile
-- Master takes the full screen when it's on it's own
screens.global_master_fill_policy = "expand"

-- ===================================================================
-- Desktop screens
-- ===================================================================

screens.screen_left_vertical = {
   output = "DVI-D-0",
   screen = nil, -- screen object
   screen_layout = awful.layout.suit.tile.bottom, -- TODO check for pure vertical layout
   screen_master_width_factor = 0.55,
   tags = {
      {
         name = "Music",
         selected = true,
         master_width_factor = 0.9
      }, {
         name = "Comms",
      }, {
         name = "Prod",
      }, {
         name = "Web",
      }
   }
}

screens.screen_center_primary = {
   output = "DP-1",
   screen = nil, -- screen object
   screen_layout = awful.layout.suit.tile,
   screen_master_width_factor = screens.global_master_width_factor,
   tags = {
      {
         name = "Code",
      }, {
         name = "Web",
         selected = true,
      }, {
         name = "Web3",
      }, {
         name = "Prod",
      }, {
         name = "Games",
         layout = awful.layout.suit.max
      }
   }
}

screens.screen_right_secondary = {
   output = "DVI-I-1",
   screen = nil, -- screen object
   screen_layout = awful.layout.suit.tile,
   screen_master_width_factor = screens.global_master_width_factor,
   tags = {
      {
         name = "Notes",
         master_width_factor = 0.5,
         selected = true,
      }, {
         name = "2",
      }, {
         name = "3",
      }, {
         name = "4",
      }, {
         name = "5",
      }
   }
}



-- ===================================================================
-- Laptop screen(s)
-- ===================================================================

screens.laptop = {
   output = "laptop",
   screen = nil, -- screen object
   screen_layout = awful.layout.suit.tile,
   screen_master_width_factor = screens.global_master_width_factor,
   tags = {
      {
         name = "Music",
         selected = true,
      }, {
         name = "Web",
      }, {
         name = "Web3",
      }, {
         name = "Prod",
      }
   }
}

screens.default_settings = screens.laptop
screens.default_settings.name = "default"

-- ===================================================================
-- Helpers
-- ===================================================================

local getSettingsForScreen = function(output)
   for k, screen in pairs(screens) do
      if (type(screen) == "table") then
         if screen.output and screen.output == output then
            return screen
         end
      end
   end

   return screens.default_settings
end

-- Pass in one of the above screens and get the screen object
local getScreenByOutput = function(output)
    local screen_by_output = nil
    for s in screen do
       local screen_name = ''
       for k, v in pairs(s.outputs) do -- array of 1 usually
          screen_name = k
       end
    
       if screen_name == output then
          screen_by_output = s
       end
    end

    return screen_by_output
end

screens.getScreenByOutput = getScreenByOutput
screens.getSettingsForScreen = getSettingsForScreen

return screens
