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

# Prefer gvim if available.
vim=gvim
which $vim > /dev/null || vim=vim


# Diff all files in large window with equal width buffers and find the first
# conflict.
$vim --nofork +"set lines=999" +"set columns=9999" +"wincmd =" +"wincmd w" +"normal gg]C" -d "$theirs" "$MERGED" "$mine"
