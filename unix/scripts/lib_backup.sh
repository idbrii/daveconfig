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

    # jwz recommends -vaxAX. this is expanded names, but without -AX
    rsync_args="--verbose --archive --one-file-system --delete --ignore-errors"
    # These seem useful to me.
    rsync_args="$rsync_args --human-readable --progress"
    case "`uname -s`" in
        Darwin)
            # macOS does not support AX
            ;;
        *)
            rsync_args=$rsync_args -AX
            ;;
    esac

    for d in $folders; do
        echo .
        echo rsync $rsync_args $backup_src/$d $backup_dst >> $backup_log
             rsync $rsync_args $backup_src/$d $backup_dst >> $backup_log
    done

    echo >> $backup_log
    echo Archiving Complete  >> $backup_log
}

echo "Collecting data from $backup_src:"
show_sizes $folders
echo "Writing data to $backup_dst."

backup_to_media

