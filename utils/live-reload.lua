local live_reload = {}

-- ===================================================================
-- Development Mode
-- ===================================================================
-- I don't know how to do this properly, but it works!

live_reload.start = function ()
    local develop_mode = os.getenv("AWESOME_DEV_MODE")
    local awful = require("awful")
    
    if develop_mode == "TRUE" then
        local home = os.getenv("HOME")
     
        awful.widget.watch(home .. '/git/my-dotfiles/awesome-config/live-reload.sh', 2, function (_, stdout)
           for line in stdout:gmatch("[^\r\n]+") do
              if line == "#reload-that-code" then
                 awesome.restart()
              end
           end
        end)
     end
end

return live_reload
