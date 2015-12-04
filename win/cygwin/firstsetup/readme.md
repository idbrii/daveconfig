# Simple permissions

If using NTFS, cygwin tries to use Access Control Lists from Windows. This
doesn't seem to work very well and resulted in vim-eunuch's auto executable
feature (`b:chmod_post`) setting *only* the executable flag and making the file
no longer readable. This is only a problem the first time you chmod a file so
it seems like it's reading the permissions as 000 when applying +x (which is
also what's displayed with `ls -l`).

Edit /etc/fstab, comment out the mounted drive, and append this to the file:

	# Following recommendation from here:
	# http://cygwin.1069669.n5.nabble.com/vim-and-file-permissions-on-Windows-7-td61390.html
	# http://georgik.sinusgear.com/2012/07/14/how-to-fix-incorrect-cygwin-permission-inwindows-7/
	# David added noacl to prevent chmod from assuming files start with 000
	# permissions. I don't care about proper permissions: I just want readonly to
	# work properly.
	none /cygdrive cygdrive binary,noacl,posix=0,user 0 0

Then close all cygwin processes. Run cygwin. Run `mount`. It should show your drive using 'noacl'.
