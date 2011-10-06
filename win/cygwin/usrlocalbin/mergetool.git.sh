#! /bin/sh

LOCAL=`cygpath -wa $1`
REMOTE=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`
/c/david/BeyondCompare3/BComp.exe $LOCAL $THEIRS $BASE $MERGED

