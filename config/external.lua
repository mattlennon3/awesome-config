-- ===================================================================
-- This file contains Global functions
-- that can be called from bash scripts
-- ===================================================================

local weekly_review = require('config.workflows.weekly-review')

-- ===================================================================
-- Weekly Review
-- ===================================================================

function Start_Weekly_Review()
    weekly_review.start()
end

function Finish_Weekly_Review()
    weekly_review.finish()
end

-- ===================================================================
-- [[placeholder]]
-- ===================================================================



