-- ===================================================================
-- Define screens
-- ===================================================================

local screens = {}

-- ===================================================================
-- Desktop screens
-- ===================================================================

screens.screen_left_vertical = "DVI-D-0"
screens.screen_center_primary = "DP-1"
screens.screen_right_secondary = "DVI-I-1"


-- ===================================================================
-- Laptop screen(s)
-- ===================================================================

-- todo

-- ===================================================================
-- Helpers
-- ===================================================================

local getScreenByOutput = function(output)
    local screen_by_output = nil
    for s in screen do
       local screen_name = ''
       for k, v in pairs(s.outputs) do
          screen_name = k
       end
    
       if screen_name == output then
          screen_by_output = s
       end
    end

    return screen_by_output
end

screens.getScreenByOutput = getScreenByOutput

return screens
