#! /bin/sh
# Since nautilus will not follow links, we copy the files.

for d in nautilus-*; do
    cp $PWD/$d/* ~/.gnome2/$d/.
done
