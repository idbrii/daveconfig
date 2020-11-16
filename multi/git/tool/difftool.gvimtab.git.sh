#! /bin/sh
# Like difftool.gvim.git.sh but it opens diffs in new tabs instead of new vim
# instance. This means git can't wait for it to complete, but good for opening
# a bunch of diffs. For git-difftool, consider using --dir-diff instead.

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

# Can't use --nofork with --remote.

# TODO: to avoid all the redraw, can we send files to vim without modifying the
# current file and without creating tabs?
gvim --servername DIFF --remote-tab-silent "$theirs" "$mine"
# Vim takes a moment to process the files. Less than this and the diff might
# not work or syntax highlighting missing.
sleep 0.995
gvim --servername DIFF --remote-expr 'david#diff#diff_args_in_tab(1)'
