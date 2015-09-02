#! /bin/sh

theirs=`cygpath -wa $1`
mine=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`

# Warning: Beyond compare now requires a pro license for 3-way merges.
# Assume it's in our path.
BComp.exe $theirs $THEIRS $BASE $MERGED

