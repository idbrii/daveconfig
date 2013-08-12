#! /bin/bash

# Bash shortcuts


# Override default implementations with cygwin version

# Quick way to view files in vim
function v { $* | gvim -R - & }

function ge {
    w "gvim --remote-silent" $*
}



#################
# cygwin

alias gogo='cygstart'

# Run windows programs from bash.
# Convert all arguments but the first to windows paths.
function w {
    p=
    for ((at=2; at <= $#; at++))
    do
        p="$p `cygpath -wa ${!at}`"
    done
    $1 $p &
}

# Run perforce from bash.
# Perforce needs to have a windows-style working directory for its clientspec
# root detection to work.
function p4 {
	export PWD=`cygpath -wa .`
	p4.exe $@
}

