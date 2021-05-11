#!/bin/sh

CONFIG_DIR="$HOME/git/my-dotfiles/awesome-config"

CHECKSUM_FILE=/tmp/awesome_checksum

CONFIG_CHECKSUM=`(cd $CONFIG_DIR; tar -cf - . | md5sum | xargs)` # xargs to remove a weird extra space
CHECKSUM_PREV_VAL=$(<$CHECKSUM_FILE)

# debug
#echo $CONFIG_CHECKSUM
#echo $CHECKSUM_PREV_VAL

# if checksum exists in /tmp/awesome_checksum
if test -f "$CHECKSUM_FILE"; then
#   then compare
    if [[ "$CHECKSUM_PREV_VAL" == "$CONFIG_CHECKSUM" ]]; then
        # No changes, don't reload
        echo "#nochanges"
    else
#       if different, run luacheck
        # echo "Running Luacheck"
        if [[ `luacheck --no-color $CONFIG_DIR | tail -1` == *"0 errors"* ]]; then
            # update checksum
            echo $CONFIG_CHECKSUM > $CHECKSUM_FILE
            echo "#reload-that-code"
        else
            echo "Luacheck failed - not reloading"
        fi
    fi
else 
    echo $CONFIG_CHECKSUM > $CHECKSUM_FILE
fi
