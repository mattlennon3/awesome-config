-- ===================================================================
-- Imports
-- ===================================================================

local awful = require("awful")

-- Icon imports



-- ===================================================================
-- Define tags
-- ===================================================================

local tags = {
    {
        name = 'Music', -- TODO: Only add this one on secondary screens?
        layout = nil
    },
    {
        name = 'Comms',
        layout = awful.layout.suit.tile.bottom
    },
    {
        name = 'Code',
        layout = nil
    },
    {
        name = 'Web',
        layout = nil
    },
    {
        name = 'Web5',
        layout = nil
    },
    {
        name = 'Games', -- TODO: Add this one only if steam opens?
        layout = awful.layout.suit.max
    }
}
 
 return tags
 