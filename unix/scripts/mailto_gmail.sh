#!/bin/sh

# Setup:
# System > Preferences > Preferred Applications and set Mail Reader to
# 	/home/$USER/data/scripts/mailto_gmail.sh %s
#
# Opens a compose with the input mailto. Strip the protocol and convert the
# subject to google's format.
gnome-open "https://mail.google.com/mail?view=cm&tf=0&to=`echo $1 | sed 's/mailto://' | sed 's/?subject=/\&su=/g' `"
