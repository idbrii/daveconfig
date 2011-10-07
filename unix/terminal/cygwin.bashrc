#! /bin/bash
#
# bashrc for Cygwin
#

# Setup some keys for rxvt/mintty
export INPUTRC=$HOME/.inputrc

# Don't break my terminal (Ctrl-S should be save!)
stty start ""
stty stop ""

export PATH=/bin:/usr/local/bin:/usr/bin:$PATH

# I don't have cygwin vim installed, but I can run Windows gvim and it blocks
export EDITOR=gvim
