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
- [x] Add the "dot" indicator above each tag when a client is open on that tag
- [ ] Control + Q closes windows (check this does not happen in old config & remove if it does not exist)
  - [ ] this may actually be a vscode/firefox thing

Screen TODO
- [x] the primary goal here is to only require music/comms on the vertical screen, games only on primary screen etc
- [x] need some contingency if we are using less than 3 monitors to put all tags on each screen
- [ ] allowing for laptop layout would be good. (maybe tag property like specific_screen for desktop only?)
- [ ] if a tag name is "Web{{i}}" replace "{{i}}" with the tag number it will be

Tag keybind todo
- [ ] If a tag has a number in the name, if you do mod + (number), jump to that tag) (Maybe not needed)

Things I can do last:
- [ ] Add the menu when you right click on the desktop
- [ ] Implement exit screen (search for show_exit_screen)
- [ ] Install screenshot software & add it to apps (& keybinds)
- [ ] different background per screen with connect_for_each_screen
- [ ] 

## Spotify issues:
https://github.com/awesomeWM/awesome/pull/2484
https://old.reddit.com/r/awesomewm/comments/bztj1c/spotify_and_raise_or_spawn/
https://old.reddit.com/r/awesomewm/comments/d8r74k/detecting_spotify/

## Debug commands
Open the Xephyr instance:
> Xephyr :1 -ac -br -noreset -screen 960x540

Run awesome inside that instance:
> DISPLAY=:1.0 awesome -c ~/.config/awesome/awesome_refactor/rc.lua --search $HOME/.config/awesome/awesome_refactor


## Credits

File structure, blocks of code and lots of other things heavily borrowed from [WillPower3309](https://github.com/WillPower3309/awesome-dotfiles). Thanks dude!
