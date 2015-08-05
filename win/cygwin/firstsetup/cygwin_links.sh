#! /bin/sh
# 
# Creates links for first-time cygwin setup.

cd /

ln -s --no-target-directory /cygdrive/c /c

if [ ! -e /home/$USER/data ] ;
	# I expect daveconfig's root links have been created. If the cygwin home
	# directory doesn't contain our data directory, then it's not pointing at
	# the Windows home. Fix that.
	mv /home/$USER /home/$USER_old
	ln -s --no-target-directory /cygdrive/c/Users/$USER /home/$USER
fi
# May need to manually move ~/davidb into /home/davidb

# Instead of this, add usrlocalbin to path.
# mv /usr/local/bin /usrlocalbin_old
# ln -s --no-target-directory /cygdrive/c/david/settings/daveconfig/win/cygwin/usrlocalbin /usr/local/bin
