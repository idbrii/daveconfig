#! /bin/sh

theirs=`cygpath -wa $1`
mine=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`

# Diff all files in large window with equal width buffers and find the first
# conflict.
gvim --nofork +"set lines=999" +"set columns=9999" +"wincmd =" +"wincmd w" +"normal gg]C" -d "$theirs" "$MERGED" "$mine"
