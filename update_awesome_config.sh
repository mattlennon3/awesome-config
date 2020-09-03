#!/bin/sh

CONFIG_LOCATION="$HOME/.config/awesome"
BACKUP_LOCATION="$HOME/.config/awesome_backup"
AWESOME_CONFIG_GIT_LOCATION="$HOME/git/my-dotfiles/awesome-config"

echo "Backing up current awesome config to $BACKUP_LOCATION"
cp -r $CONFIG_LOCATION      $BACKUP_LOCATION || echo "error backing up the awesome config"
echo "Copying config from $AWESOME_CONFIG_GIT_LOCATION to $CONFIG_LOCATION"
cp -r $AWESOME_CONFIG_GIT_LOCATION      $CONFIG_LOCATION
echo "Done"
