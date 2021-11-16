-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local screens = require("config.screens")
local logger = require("utils.log")

-- ===================================================================
-- Weekly Review
-- ===================================================================

local weekly_review = {}

local main_screen = screens.getScreenByOutput(screens.screen_center_primary.output)
local right_secondary_screen = screens.getScreenByOutput(screens.screen_right_secondary.output)

-- Finds clients if they are not where they were expected to be
local find_review_clients = function ()
    logger.log('find_review_clients not implemented')
    for _, c in ipairs(client.get()) do
        -- do something
    end
end

weekly_review.start = function ()
    -- bail for laptop etc
    if main_screen == nil then
        return
    end

    -- create a new "review" tag on the main screen
    awful.tag.add("Review", {
        layout = awful.layout.suit.tile,
        screen = main_screen,
        gap = 100,
        selected = true,
        volatile = true,
        gap_single_client = true,
    })

    local review_tag = awful.tag.find_by_name(main_screen, "Review")
    local notes_tag  = awful.tag.find_by_name(right_secondary_screen, "Notes")

    local notes_clients = notes_tag:clients()

    if notes_clients == nil then
        notes_clients = find_review_clients()
    end
    
    -- move todoist and obsidian to new tag
    for _, c in ipairs(notes_clients) do
        c:move_to_tag(review_tag)
    end
    
    review_tag:view_only()
end

weekly_review.finish = function ()
    -- bail for laptop etc
    if main_screen == nil then
        return
    end

    local review_tag = awful.tag.find_by_name(main_screen, "Review")
    local review_clients = review_tag:clients()

    if review_clients == nil then
        review_clients = find_review_clients()
    end

    -- apply rules (should move most things back to notes)
    for _, c in ipairs(review_clients) do
        awful.rules.apply(c)
    end

    -- delete the "review" tag
    -- tag is volatile so should delete itself
end


return weekly_review
