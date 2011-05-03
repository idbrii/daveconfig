#! /bin/sh
# Invoke Scale. Note that this depends on the bindings set for compiz.
# Requires xdotool

# To make a unity launcher created a file called
#   /usr/share/applications/expose.desktop
# Containing (ensure Exec path is correct):
#   [Desktop Entry]
#   Comment=Switch between programs
#   Exec=/home/user/scripts/compiz-scale.sh
#   Icon=gnome-klotski
#   Name=Exposé
#   Terminal=false
#   Type=Application
#   Version=1.0

xdotool keydown Super && xdotool key Tab
xdotool keyup Super

