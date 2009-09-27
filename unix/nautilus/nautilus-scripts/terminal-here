#!/bin/sh
# From Chris Picton
# Replaces a Script by Martin Enlund
# Modified to work with spaces in path by Christophe Combelles

# This script either opens in the current directory, 
# or in the selected directory

base="`echo $NAUTILUS_SCRIPT_CURRENT_URI | cut -d'/' -f3- | sed 's/%20/ /g'`"
if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
     dir="$base"
else 
     while [ ! -z "$1" -a ! -d "$base/$1" ]; do shift; done
     dir="$base/$1"
fi

gnome-terminal --working-directory="$dir"
