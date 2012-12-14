#! /bin/sh
# 
# Creates links for first-time cygwin setup.

cd /

ln -s --no-target-directory /cygdrive/c /c

mv /home/$USER /home/$USER_old
ln -s --no-target-directory /cygdrive/c/Users/$USER /home/$USER
# May need to manually move ~/davidb into /home/davidb

mv /usr/local/bin /usrlocalbin_old
ln -s --no-target-directory /cygdrive/c/david/settings/daveconfig/win/cygwin/usrlocalbin /usr/local/bin
