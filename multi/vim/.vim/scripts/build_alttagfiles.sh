#! /bin/sh
# vim:set fdm=marker:
# Build the LookupFile database

cscope=$1
if [ $# -lt 1 ] ; then
    # assume plain cscope if we got no input
    cscope=cscope
fi

filetype=$2

tagdir=.
tagfile=$tagdir/filenametags

cd $tagdir


# Build filenametags	{{{
echo "!_TAG_FILE_SORTED	2	/2=foldcase/"> $tagfile
if [ "$filetype" == "cpp" ] ; then
    # Probably a big c++ project, so use the simple format
    find . -type f -iname "*.cpp" -o -iname "*.h" -printf "%f\t%p\t1\n" | sort -f >> $tagfile

else
    # Don't know what we are so include anything that's not binary or junk (from vimdoc)
    # DavidAdd: Directories: .git
    # DavidAdd: Files: pyc
    find . \( -name .git -o -name .svn -o -wholename ./classes \) -prune -o -not -iregex '.*\.\(pyc\|jar\|gif\|jpg\|class\|exe\|dll\|pdd\|sw[op]\|xls\|doc\|pdf\|zip\|tar\|ico\|ear\|war\|dat\).*' -type f -printf "%f\t%p\t1\n" | sort -f >> $tagfile

fi

# }}}


# Build cscope	{{{
# Create the cscope.files from filenametags
cut -f2 $tagfile | tail --lines=+2 > cscope.files

# Build cscope database
#	-b              Build the database only.
#	-k              Kernel Mode - don't use /usr/include for #include files.
#	-q              Build an inverted index for quick symbol seaching.
# May want to consider these flags
#	-m "lang"       Use lang for multi-lingual cscope.
#	-R              Recurse directories for files.
$cscope -b -q -k

# }}}


cd -

