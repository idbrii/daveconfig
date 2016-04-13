#! /bin/bash
# vim:set fdm=marker:

# Build the filelist, tag file, and cscope databases
# usage:
#   buildtags.sh cscope-binary lang [directories to search]
#
# example to build C++ in current directory recursively:
#   buildtags.sh cscope cpp
# example for the same but only tags (no filelist or cscope):
#   buildtags.sh tagonly cpp

# Installing dependents:
#   aptinstall exuberant-ctags cscope
#   pip install pycscope

cscope=$1
if [ $# -lt 1 ] ; then
    # assume plain cscope if we got no input
    cscope=cscope
fi

filetype=$2

search_dirs=.
if [ $# -gt 2 ] ; then
    # search directories passed in

	# ignore cscope and filetype
	shift
	shift
	# use remaining parameters
    search_dirs=$*
fi

tagdir=$PWD
tagfile=$tagdir/filelist

cd $tagdir


# Build filelist	{{{
rm $tagfile
if [ "$filetype" == "cpp" ] ; then
    # Probably a big c++ project, so use the simple format
    find $search_dirs -type f \( -iname "*.cpp" -o -iname "*.h" \) -print | sort -f >> $tagfile

elif [ "$filetype" == "unreal" ] ; then
	# A big unreal c++ project, so use the simple format. Ignore generated code
	# in the Intermediate folder (a nuisance in plugins that don't have a fixed
	# path format).
    find $search_dirs -type f \( -iname "*.cpp" -o -iname "*.h" \) -print | grep -v "Intermediate.Build" | sort -f >> $tagfile

elif [ "$filetype" == "cs" ] ; then
    # C sharp code. don't include examples which are often alongside.
    find $search_dirs -not \( -name "examples" -prune \) -a -not \( -name "obj" -prune \) -a \( -type f -iname "*.cs" -o -iname "*.xaml" \) -print | sort -f >> $tagfile

elif [ "$filetype" == "android" ] ; then
    # Android uses java and xml. Assume we're in the source directory
    find $tagdir ../res -type f \( -iname "*.xml" -o -iname "*.java" \) -print | sort -f >> $tagfile

elif [ "$filetype" == "java" ] ; then
    # The only types we're interested in are java
    find $search_dirs -type f -iname "*.java" -print | sort -f >> $tagfile

else
    # Don't know what we are so include anything that's not binary or junk (from vimdoc)
    # DavidAdd: Files: .git tags filelist
    # DavidAdd: Filetypes: pyc out
    # DavidAdd: Folder: v (for virtualenv)
    find $search_dirs \( -name .git -o -name v -o -name .svn -o -name .bzr -o -name tags -o -name filelist -o -wholename ./classes \) -prune -o -not -iregex '.*\.\(pyc\|jar\|gif\|jpg\|class\|exe\|dll\|pdd\|sw[op]\|xls\|doc\|pdf\|zip\|tar\|ico\|ear\|war\|dat\|out\).*' -type f -print | sort -f >> $tagfile

fi

# convert cygwin paths to windows paths
sed -i -e"s,^/cygdrive/\([[:alpha:]]\)/,\1:/," $tagfile
# I usually make a link in the root to each drive letter (/c for c:)
sed -i -e"s,^/\([[:alpha:]]\)/,\1:/," $tagfile
# }}}

# Build ctags and cscope	{{{
# Fixup the filelist

case $OSTYPE in
	cygwin*)
	# mlcscope needs full paths, so replace the relative path with the fully
	# qualified path
	# TODO: cygwin replaced mlcscope with cscope. Does it still have this problem?
	sed -i -e"s|^\./|$tagdir/|" $tagfile
;;
	*)
	# cscope doesn't seem to need full paths
	# do nothing.
;;
esac

case $filetype in
    cpp|cs|c)
        ctags --c++-kinds=+p --fields=+iaS --extra=+q -L $tagfile
        ;;
    *)
        ctags -L $tagfile
        ;;
esac

if [ $cscope == "tagonly" ] ; then
	rm $tagfile

else
	case $filetype in
		python)
			# Requires the python package pycscope:
			#   pip install pycscope
			pycscope -i filelist
			;;
		*)
			# Build cscope database
			#	-b              Build the database only.
			#	-k              Kernel Mode - don't use /usr/include for #include files.
			#	-q              Build an inverted index for quick symbol seaching.
			# May want to consider these flags
			#	-m "lang"       Use lang for multi-lingual cscope.
			#	-R              Recurse directories for files.
			$cscope -b -q -k -i filelist
			;;
	esac
fi

# }}}


cd -

