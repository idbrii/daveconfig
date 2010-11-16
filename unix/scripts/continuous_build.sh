#! /bin/bash

# Rebuild tags every minute

if [ $# -lt 1 ] ; then
    echo
    echo Error: You must provide the filetype
    echo Example: $0 java
    echo
    exit -1
fi
lang=$1

while true ; do
    echo building...
    ctags -R .
    bash ~/.vim/scripts/build_alttagfiles.sh cscope $lang
    echo done. sleeping.
    sleep 1m
done

