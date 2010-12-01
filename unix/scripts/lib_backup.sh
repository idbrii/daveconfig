#! /bin/bash

# Requires three arguments:
#  - what we're backing up
#  - where we're putting it
#  - and a list of folders to back up
#
# For example, backup up our code and text data:
#   bash lib_backup.sh /data /backup/data code text

backup_src=$1 ; shift
backup_dst=$1 ; shift
folders=$*

backup_log=/tmp/backup.log

function show_sizes()
{
    folderlist=$*
    cd $backup_src
    echo $folderlist
    du -sh $folderlist
    echo
    cd -
}

function write_log_header()
{
    backup_log=$1
    echo >> $backup_log
    echo >> $backup_log
    echo $0 >> $backup_log
    date >> $backup_log
}

# Created from jwz's PSA:
# http://www.jwz.org/doc/backups.html
function backup_to_media()
{
    write_log_header $backup_log

    for d in $folders; do
        echo .
        echo rsync -vaxAX --delete --ignore-errors $backup_src/$d $backup_dst >> $backup_log
             rsync -vaxAX --delete --ignore-errors $backup_src/$d $backup_dst >> $backup_log
    done

    echo >> $backup_log
    echo Archiving Complete  >> $backup_log
}

show_sizes $folders

backup_to_media

