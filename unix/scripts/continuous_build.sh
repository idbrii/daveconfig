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
    if [ $1 == "android" ] ; then
        bash ~/.vim/scripts/build_android_tags.sh
    else
        ctags -R .
        bash ~/.vim/scripts/build_alttagfiles.sh cscope $lang
    fi
    echo done. sleeping.
    sleep 1m
done

