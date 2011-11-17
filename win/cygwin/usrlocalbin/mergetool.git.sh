#! /bin/sh

LOCAL=`cygpath -wa $1`
REMOTE=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`

# Beyond compare now requires a pro license for 3-way merges.
#/c/david/BeyondCompare3/BComp.exe $LOCAL $THEIRS $BASE $MERGED

# Info from: http://www.andymcintosh.com/?p=33
/c/david/Perforce/p4merge.exe "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
