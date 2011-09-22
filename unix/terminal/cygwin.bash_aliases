#! /bin/bash

# Bash shortcuts


# Override default implementations with cygwin version

# Quick way to view files in vim
function v { $* | gvim -R - & }

function ge {
    w "gvim --remote-silent" $*
}
function move_and_link() {
    mv $1 $2
    ln -sv $2 $1
}

# Start serving the local directory as a website
alias webserve='python -m SimpleHTTPServer'



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

