#! /bin/sh

theirs=`cygpath -wa $1`
mine=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`

gvim --nofork -d "$theirs" "$MERGED" "$mine"
