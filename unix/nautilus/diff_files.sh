#! /bin/sh
# Since nautilus will not follow links, we diff to bring our changes back.

for d in nautilus-*; do
    meld $PWD/$d ~/.gnome2/$d
done
