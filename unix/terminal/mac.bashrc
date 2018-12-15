#! /bin/bash
#
## bashrc for Mac OSX
#

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# Mac doesn't have bash_completion where unix.bashrc is looking. homebrew
# installs to /usr/local. Use brew to find the right spot.
#
# Use `brew install git` to get newest git and completion.
# Dropped git-flow-completion.bash into completion dir from here:
# https://github.com/bobthecow/git-flow-completion/blob/master/git-flow-completion.bash
#
# Source: https://github.com/bobthecow/git-flow-completion/issues/46#issuecomment-332724240
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
fi
if [ -f $(brew --prefix)/etc/bash_completion.d/git-flow-completion.bash ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-flow-completion.bash
fi

# Setting PATH for MacPython 2.4
#python_bin="/Library/Frameworks/Python.framework/Versions/Current/bin"

## add bin
bin=$HOME/bin
#PATH=$bin:$python_bin:$PATH
PATH=$bin:$PATH
export PATH

if [ $SHLVL -eq 1 ]; then
    # we invoked from a Terminal window, not somewhere else.
    # note that this is really slow :(
    /usr/bin/osascript ~/data/settings/daveconfig/mac/terminal/RandomColorTerminal.applescript
fi

