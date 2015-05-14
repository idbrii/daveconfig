#! /bin/sh

if [ `which cygpath` ] ; then
    theirs=`cygpath -wa $1`
    mine=`cygpath -wa $2`
    #BASE=`cygpath -wa $3`
    #MERGED=`cygpath -wa $4`
else
    theirs=$1
    mine=$2
    #BASE=$3
    #MERGED=$4
fi


# why do these look wrong?
#echo theirs=$LOCAL >> /tmp/out
#echo mine=$REMOTE >> /tmp/out
#echo BASE=$BASE >> /tmp/out

gvim --nofork -d "$theirs" "$mine"
