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

function w {
    p=
    for ((at=2; at <= $#; at++))
    do
        p="$p `cygpath -wa ${!at}`"
    done
    $1 $p &
}

function p4 {
	export PWD=`cygpath -wa .`
	p4.exe $@
}

