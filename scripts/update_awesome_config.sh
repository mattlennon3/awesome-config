#!/bin/sh

CONFIG_LOCATION="$HOME/.config/awesome"
BACKUP_LOCATION="$HOME/.config/awesome_backup"
AWESOME_CONFIG_GIT_LOCATION="$HOME/git/my-dotfiles/awesome-config"
# TODO: Rsync with -u will not overwrite if the destination is newer. This is not helpful when reverting changes
echo "Backing up current awesome config to $BACKUP_LOCATION"
rsync -au "$CONFIG_LOCATION/" $BACKUP_LOCATION --exclude=.git/ || echo "error backing up the awesome config"
echo "Copying config from $AWESOME_CONFIG_GIT_LOCATION to $CONFIG_LOCATION"
rsync -au "$AWESOME_CONFIG_GIT_LOCATION/" $CONFIG_LOCATION
echo "Done"
