# Awesome Dotfiles

## TODO List
- find a MUCH better way of running & debugging this as you go
- Figure out the top bar configuration & creation
  - This will involve figuring out the widgets that have been made


- NEXT:
- [x] Find out what the create_rules function is about. 
- [x] Required to get clientbuttons working (click to focus etc)

- [x] add startup_errors check (look in old rc.lua)

- [x] get taglist_buttons working

- [x] Keybinds to open windows

Things I can do last:
- [ ] Add the menu when you right click on the desktop
- [ ] Implement exit screen (search for show_exit_screen)
- [ ] Add the "dot" indicator above each tag when a client is open on that tag
- [ ] Install screenshot software & add it to apps (& keybinds)



## Debug commands
Open the Xephyr instance:
> Xephyr :1 -ac -br -noreset -screen 960x540

Run awesome inside that instance:
> DISPLAY=:1.0 awesome -c ~/.config/awesome/awesome_refactor/rc.lua --search $HOME/.config/awesome/awesome_refactor


## Credits

File structure, blocks of code and lots of other things heavily borrowed from [WillPower3309](https://github.com/WillPower3309/awesome-dotfiles). Thanks dude!