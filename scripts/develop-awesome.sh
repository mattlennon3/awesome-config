#!/bin/sh

export AWESOME_DEV_MODE=TRUE

Xephyr :1 -ac -br -noreset -screen 960x540 &
# Xephyr :1 -ac -br -noreset -screen 1920x1080 &

DISPLAY=:1.0

sleep 2

awesome -c $HOME/git/dots/awesome-config/rc.lua 
#awesome -c ~/git/dots/awesome-config/rc.lua --search $HOME/.config/awesome

