#! /bin/bash
#
# bashrc for Cygwin
#

# Setup some keys for rxvt/mintty
export INPUTRC=$HOME/.inputrc

export PATH=/bin:/usr/local/bin:/usr/bin:$PATH

# I don't have cygwin vim installed, but I can run Windows gvim and it blocks.
# --nofork doesn't seem to be required.
export VISUAL=gvim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
