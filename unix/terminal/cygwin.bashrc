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
