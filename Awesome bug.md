# Imports don't respect specified config directory

launch awesome with the -c flag and specifiy a config dir
e.g 

`awesome -c $HOME/git/my-dotfiles/awesome-config/rc.lua `

in both `$HOME/.config/awesome/rc.lua` and the above config location this line exists:

```
require('utils.live-reload').start()
```

In
`$HOME/.config/awesome/live-reload.lua`
There is this line:
`print("primary config location")`

In 
`$HOME/.config/awesome/utils/live-reload.lua`
There is this line:
`print("secondary config location")`

What is printed when `awesome -c $HOME/git/my-dotfiles/awesome-config/rc.lua ` is ran:
`print("primary config location")`

## Related Issues

https://github.com/awesomeWM/awesome/issues/218

