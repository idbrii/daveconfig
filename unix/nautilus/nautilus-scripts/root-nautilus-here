#!/bin/sh
# root-nautilus-here
# opens a root-enabled instance of a nautilus window in selected location
# requires sudo priviledges and gksudo, which may involve security risks.
#Install in your ~/Nautilus/scripts directory.
#
# Placed in the public domain by Shane T. Mueller 2001
# Fixes provided by Doug Nordwall
#
# 2004.04.18 -- keith@penguingurus.com - Added gksudo usage to provide popup
#               password window if sudo has expired.  Line only echos got
#               root to std output.  But gksudo updates your sudo access
#               privs, so running nautilus with sudo will succeed
#               without asking for a password.


foo=`gksudo -u root -k -m "enter your password for nautilus root access" /bin/echo "got r00t?"`
sudo nautilus --no-desktop $NAUTILUS_SCRIPT_CURRENT_URI
