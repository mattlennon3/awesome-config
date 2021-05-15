local home = os.getenv("HOME")

local content = home .. "/Content/Icons/"

local icon_paths = {
    windows10 = content .. "windows10.png",
    linux = content .. "iconfinder_linux_tux.png"
}

return { icon_paths = icon_paths } -- object to add actual images later
