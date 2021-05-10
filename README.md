# Awesome Dotfiles

## Libraries
// todo incomplete
cyclefocus
kikito/inspect.lua
luacheck / luarocks

## TODO List
- Figure out the top bar configuration & creation
  - This will involve figuring out the widgets that have been made
- [x] Find out what the create_rules function is about. 
- [x] Required to get clientbuttons working (click to focus etc)
- [x] add startup_errors check (look in old rc.lua)
- [x] get taglist_buttons working
- [x] Keybinds to open windows
- [x] Add the "dot" indicator above each tag when a client is open on that tag
- [x] Control + Q closes windows
- [x] Show spotify on Music & Comms tag
- [x] Add keybinds:
  - [x] alt+tab for clients within tag
    - [ ] fix alt-tab rofi issue (keys.lua)
  - [ ] ~~alt+` for tags (between screens too?)~~
- [x] do not show battery on desktop
- [x] change autostart programs/tags depending on device?
- [ ] find a better way of running & debugging this as you go
- [ ] system notification helper
- [ ] ~~reading left aligned text in a browser is annoying when its the only window as its to the left,~~ solved by spotlight & firefox reader mode
  - [ ] ~~add margin to the left/right side of the client to center the browsers text~~
- [x] gap increase/decrease/toggle hotkeys
- [ ] shortcut to make client active on all tags

### Screen TODO
- [x] the primary goal here is to only require music/comms on the vertical screen, games only on primary screen etc
- [x] need some contingency if we are using less than 3 monitors to put all tags on each screen
- [x] adding laptop layout would be good. (maybe tag property like specific_screen for desktop only?)
- [x] if a tag name is "Web{{i}}" replace "{{i}}" with the tag number it will be
- [ ] set default tag per screen. Should be screen prop rather than selected_tag_for_screen

### Tag TODO
- [x] Add screenshot client name into the file name.
  - [x] create a folder for the client name and place it there?
- [x] If a tag has a number in the name, if you do mod + (number), jump to that tag) (Automatically worked)
- [ ] add/rename tags on the fly

### Things I can do last:
- [ ] Add the menu when you right click on the desktop
- [ ] Implement exit screen (search for show_exit_screen)
- [x] Install screenshot software & add it to apps (& keybinds)
- [ ] different background per screen with connect_for_each_screen
- [ ] wallpaper driven from a folder rather than a specific file
- [ ] separate wallpaper for portrait monitor
- [ ] sort out imports? keys.lua is imported in 2 different files so runs twice, which could be an issue. Maybe assign the result to a global and use it if available
- [ ] when copying a screenshot to the clipboard, don't seem to be able to paste into every program (i.e works when pasting to discord chat/whatsapp but not into a directory)
- [ ] create a PKGBUILD to keep track of what is required to be installed, rather than just listing the programs in apps.lua
- [ ] youtube-dl rofi prompt
- [ ] shortcut to call dmenu-run, but will create a new tag to hold the client instead of opening on the current tag (could try and generate the tag name from the client). Handy for maximized clients, prusa-slicer, freecad etc
- [ ] gimp maximize on open
- [ ] delayed autostart for some apps (spotify)
- [ ] ctrl + alt + v to reset volume to 40% (set this on start too?)
- [ ] autostart spotify should check if it's already running and not run if it is
- [ ] margin around CPU temp widget
- [ ] better alt tab https://github.com/blueyed/awesome-cyclefocus/
- [ ] awful.urgent.delete (c) (for discord and todoist who are always urgent on launch)
- [ ] add way to serialise (print) objects https://github.com/kikito/inspect.lua ?
- [ ] Figure out rule callback functions


vertical stacking layout:

I
\----------------------------  
.............Top  
I
\----------------------------  
...........Middle  
I
\----------------------------  
...........Bottom  
I
\----------------------------  


## Spotify issues:
https://github.com/awesomeWM/awesome/pull/2484  
https://old.reddit.com/r/awesomewm/comments/bztj1c/spotify_and_raise_or_spawn/  
https://old.reddit.com/r/awesomewm/comments/d8r74k/detecting_spotify/  
  
## Debug commands

### Debug TODO
- [ ] add script to launch both debug commands into a terminal
  - [ ] don't keep opening startup programs in Xephyr window (i.e when debugging/developing)

Open the Xephyr instance:
```
Xephyr :1 -ac -br -noreset -screen 960x540
```
Run awesome inside that instance:
```
AWESOME_DEV_MODE=TRUE;
DISPLAY=:1.0 awesome -c ~/git/my-dotfiles/awesome-config/rc.lua --search $HOME/.config/awesome
```

As a one-liner
```
AWESOME_DEV_MODE=TRUE; Xephyr :1 -ac -br -noreset -screen 960x540 & sleep 2 && DISPLAY=:1.0 awesome -c ~/git/my-dotfiles/awesome-config/rc.lua --search $HOME/.config/awesome
```

## Listen for keyboard presses to find out what keycode to bind
Get keyboard id
> xinput list
Start listener
> xinput test 11
or try this
> xmodmap -pke | less

## Useful links
some helpful screen code https://github.com/raphaelfournier/Dotfiles/blob/master/awesome/.config/awesome/rc.lua

interface with awesomewm from the command line:  
https://awesomewm.org/doc/manpages/awesome-client.1.html

Dangers in spawning commands
https://stackoverflow.com/a/52636847/3033813

## Credits

File structure, blocks of code and lots of other things heavily borrowed from [WillPower3309](https://github.com/WillPower3309/awesome-dotfiles). Thanks dude!
