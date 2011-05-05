#!/bin/sh
# Opens a compose with the input mailto. Strip the protocol and convert the
# subject to google's format.

# Setup:
# System > Preferences > Preferred Applications and set Mail Reader to
# 	/home/$USER/data/scripts/mailto_gmail.sh %s
#

# Custom mail apps aren't available in 11.04. Create this desktop file:
## A desktop file to create a mail provider to handle mailto links.
## From: https://bugs.launchpad.net/ubuntu/+source/gnome-control-center/+bug/708382/comments/24
##
## Add to:
##   ~/.local/share/applications/mailto.desktop
##
## You must run this after adding this file:
##   update-desktop-database ~/.local/share/applications/
##
#[Desktop Entry]
#Encoding=UTF-8
#Name=mailto
#Exec=/path/to/mailto_gmail.sh %u
#Terminal=false
#X-MultipleArgs=false
#Type=Application
#Icon=mail_new
#Categories=Application;Network;Email;
#MimeType=x-scheme-handler/mailto;


gnome-open "https://mail.google.com/mail?view=cm&tf=0&to=`echo $1 | sed 's/mailto://' | sed 's/?subject=/\&su=/g' `"
