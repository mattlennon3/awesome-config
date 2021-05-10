-----------------------------------------------------------
-- Treat this as a lua file
-- https://luacheck.readthedocs.io/en/stable/config.html
-----------------------------------------------------------

new_globals = {
    "awesome",
    "client",
    "screen",
    "root",
    "mouse",
    "tag"
}

exclude_files = {
    "old-outdated/"
}

max_line_length = false

-- https://luacheck.readthedocs.io/en/stable/warnings.html#list-of-warnings
ignore = {
    -- whitespace
    "611",
    "612",
    "614",

    -- unused vars
    "311",
    "213"
}
