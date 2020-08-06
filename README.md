# Awesome Dotfiles

## TODO List
- find a MUCH better way of running & debugging this as you go
- Figure out the top bar configuration & creation
  - This will invove figuring out the widgets that have been made

- Keybinds next to open windows
- Add the menu when you right click on the desktop
- Implement exit screen (search for show_exit_screen)
- Install screenshot software & add it to apps (& keybinds)


## Debug commands
Open the Xephyr instance:
> Xephyr :1 -ac -br -noreset -screen 960x540

Run awesome inside that instance:
> DISPLAY=:1.0 awesome -c ~/.config/awesome/awesome_refactor/rc.lua --search $HOME/.config/awesome/awesome_refactor


## Credits

File structure and lots of other things heavily borrowed from [WillPower3309](https://github.com/WillPower3309/awesome-dotfiles). Thanks dude!