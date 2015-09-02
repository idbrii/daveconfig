#! /bin/sh

theirs=`cygpath -wa $1`
mine=`cygpath -wa $2`
BASE=`cygpath -wa $3`
MERGED=`cygpath -wa $4`

# Use perforce. Assume it's in our path.
# Parameter info from: http://www.andymcintosh.com/?p=33
p4merge.exe "$BASE" "$theirs" "$mine" "$MERGED"
