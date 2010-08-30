#! /bin/bash

# Move the active window to fill the left or right of the screen.
# Requires wmctrl

if [ $# -lt 1 ] ; then
    echo Error - insufficient inputs
    echo -e "Usage: $0 [left|right|top|bottom|fill]"
    exit 1
fi

# SIDE = left or right to fill side. top or bottom to move
SIDE=$1

# get the screen height and width
DIMENSIONS=`xdpyinfo | grep 'dimensions:' | cut -f 2 -d ':'`
WIDTH=`echo $DIMENSIONS | cut -f 1 -d 'x'`
HEIGHT=`echo $DIMENSIONS | cut -f 2 -d 'x' | cut -f 1 -d ' '`
# get half of the screen height and width
HALF_HEIGHT=$(($HEIGHT/2))
HALF_WIDTH=$(($WIDTH/2))

# left or right side
if [ $SIDE == "left" ] ; then
    X_POSITION=0
else
    X_POSITION=$HALF_WIDTH
fi

# If we are maximized, then we have to unmaximize before we can move or resize
wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert

if [ $SIDE == "top" ] ; then
    # Move to top half of screen
    wmctrl -r :ACTIVE: -e"0,-1,0,-1,-1"

elif [ $SIDE == "bottom" ] ; then
    # Move to bottom half of screen
    wmctrl -r :ACTIVE: -e"0,-1,$HEIGHT,-1,$HALF_HEIGHT"

elif [ $SIDE == "fill" ] ; then
    # Force maximize
    wmctrl -r :ACTIVE: -e"0,0,0,$WIDTH,$HEIGHT"

else
    # Half screen
    #   full height
    wmctrl -r :ACTIVE: -b add,maximized_vert
    #   half the screen width and move position
    wmctrl -r :ACTIVE: -e"0,$X_POSITION,0,$HALF_WIDTH,-1"

fi
