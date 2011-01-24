#! /bin/bash

# LVDS1 is my laptop monitor and VGA1 is my external monitor.
# These names can be found by running xrandr with no arguments.

# auto detect all connected monitors
xrandr --auto

if [ "$1" == "both" ] ; then
    # use best settings for both monitors
    xrandr --output LVDS1 --preferred --output VGA1 --above LVDS1 --primary --preferred
else
    # only use external monitor
    xrandr --output LVDS1 --off --output VGA1 --primary --preferred
fi

