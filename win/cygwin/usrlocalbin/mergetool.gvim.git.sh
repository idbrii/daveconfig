#! /bin/bash

if [ `which cygpath` ] ; then
    theirs=`cygpath -wa $1`
    mine=`cygpath -wa $2`
    BASE=`cygpath -wa $3`
    MERGED=`cygpath -wa $4`
else
    theirs=$1
    mine=$2
    BASE=$3
    MERGED=$4
fi

# Diff all files in large window with equal width buffers and find the first
# conflict.
gvim --nofork +"set lines=999" +"set columns=9999" +"wincmd =" +"wincmd w" +"normal gg]C" -d "$theirs" "$MERGED" "$mine"
