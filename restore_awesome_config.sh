#!/bin/sh

CONFIG_LOCATION="$HOME/.config/awesome"
BACKUP_LOCATION="$HOME/.config/awesome_backup"

echo "Restoring awesome config from $BACKUP_LOCATION"
cp -r $BACKUP_LOCATION      $CONFIG_LOCATION       || echo "error restoring the awesome config"
echo "Done"
