#! /bin/bash
#

#################
# Mac (darwin)

alias gogo='open'
# Ideally, I'd use $VIMRUNTIME. Didn't work last time I was on a mac.
alias les='/usr/local/Cellar/macvim/*/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'
# safer way to delete
function trash
{
    mv $* ~/.Trash/.
}
