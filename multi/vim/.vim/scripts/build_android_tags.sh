#! /bin/sh
# Build ctags, filenametags, and cscope db for the current project
#
# Android projects have libraries and I'd like to include all of their
# information too, so we use the project file (which determines which libraries
# are included in an android project) to find all of the directories to crawl.
# Note that the directory structure is inflexible:
#   - Expects to be in the root directory for an android project
#   - Builds tag files in the parent directory (each project will clobber
#   previous builds)


# Determine the directories to index {{{
current=`basename $PWD`
# include referenced libraries
projects="$current `grep android.library.reference default.properties | cut -d= -f2- | cut -c4- `"
for p in $projects; do
    tag_dirs="$tag_dirs $p/src $p/gen"
done
# }}}

# Put build output in the android/ parent folder
cd ..

# Build tags database {{{
ctags -R $tag_dirs
# }}}

# Build the LookupFile database {{{
cscope=cscope

tagdir=$PWD
tagfile=$tagdir/filenametags

# Build filenametags	{{{
echo "!_TAG_FILE_SORTED	2	/2=foldcase/"> $tagfile

# Android uses java and xml. Only include xml files for the current project.
find $tag_dirs $current/res -type f \( -iname "*.xml" -o -iname "*.java" \) -printf "%f\t%p\t1\n" | sort -f >> $tagfile

# }}}


# Build cscope	{{{
# Create the cscope.files from filenametags
# cscope needs full paths, so replace the relative path with the fully
# qualified path
# Exclude generated code and xml from cscope. It's not helpful.
cut -f2 $tagfile | tail --lines=+2 | sed -e"s|^\./|$tagdir/|" | grep -v -e .xml -e R.java > cscope.files

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

# vim:set fdm=marker:
