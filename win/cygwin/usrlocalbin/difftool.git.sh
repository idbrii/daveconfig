#! /bin/sh

LOCAL=`cygpath -wa $1`
REMOTE=`cygpath -wa $2`
BASE=`cygpath -wa $3`

# why do these look wrong?
#echo local=$LOCAL
#echo REMOTE=$REMOTE
#echo BASE=$BASE
/c/david/BeyondCompare3/BComp.exe $BASE $LOCAL /leftreadonly

