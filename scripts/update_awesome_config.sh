#!/bin/sh

CONFIG_LOCATION="$HOME/.config/awesome"
AWESOME_CONFIG_GIT_LOCATION="$HOME/git/dots/awesome-config"

# Wipe previous config dir
echo "Deleting $CONFIG_LOCATION"
rm -rf $CONFIG_LOCATION

# Copy everything to config dir
echo "Copying config from $AWESOME_CONFIG_GIT_LOCATION to $CONFIG_LOCATION"
cp -r $AWESOME_CONFIG_GIT_LOCATION $CONFIG_LOCATION

echo "Done"
