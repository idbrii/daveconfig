#! /bin/sh

theirs=`cygpath -wa $1`
mine=`cygpath -wa $2`
BASE=`cygpath -wa $3`

# why do these look wrong?
#echo theirs=$LOCAL >> /tmp/out
#echo mine=$REMOTE >> /tmp/out
#echo BASE=$BASE >> /tmp/out

BComp.exe $theirs $mine /leftreadonly

