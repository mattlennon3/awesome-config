-- ===================================================================
-- Imports
-- ===================================================================

local awful = require("awful")
local screens = require("screens")

-- Icon imports

-- ===================================================================
-- Define tags
-- ===================================================================

local tags = {
    {
        name = 'Music',
        layout = awful.layout.suit.tile.bottom,
        specific_screen = screens.screen_left_vertical,
        master_width_factor = 0.9
    },
    {
        name = 'Comms',
        layout = awful.layout.suit.tile.bottom,
        specific_screen = screens.screen_left_vertical
    },
    {
        name = 'Notes',
        layout = nil,
        specific_screen = screens.screen_right_secondary,
        master_width_factor = 0.5
    },
    {
        name = 'Code',
        layout = nil,
        specific_screen = nil
    },
    {
        name = 'Web',
        layout = nil,
        specific_screen = nil
    },
    {
        name = 'Web{{i}}',
        layout = nil,
        specific_screen = nil
    },
    {
        name = 'Sound',
        layout = nil,
        specific_screen = screens.screen_right_secondary,
        master_width_factor = 0.5
    },
    {
        name = 'Prod',
        layout = nil,
        specific_screen = screens.screen_center_primary
    },
    {
        name = 'Games', -- TODO: Add this one only if steam/lutris opens?
        layout = awful.layout.suit.max,
        specific_screen = screens.screen_center_primary
    }
}

return tags
