#! /bin/bash
#
## bashrc for Mac OSX
#

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Apple wants me to switch to zsh
export BASH_SILENCE_DEPRECATION_WARNING=1

# Mac doesn't have bash_completion where unix.bashrc is looking. homebrew
# installs to /usr/local. Use brew to find the right spot.
#
# Use `brew install git` to get newest git and completion.
# Dropped git-flow-completion.bash into completion dir from here:
# https://github.com/bobthecow/git-flow-completion/blob/master/git-flow-completion.bash
#
# Source: https://github.com/bobthecow/git-flow-completion/issues/46#issuecomment-332724240
# TODO: Assert "$(brew --prefix)" == "/usr/local"
if [ -r /usr/local/etc/profile.d/bash_completion.sh ] ; then
  # Will invoke /usr/local/etc/bash_completion Not sure why the indirection, but brew suggests this is best.
  . /usr/local/etc/profile.d/bash_completion.sh
fi
if [ -r /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  . /usr/local/etc/bash_completion.d/git-completion.bash
fi
if [ -r /usr/local/etc/bash_completion.d/git-flow-completion.bash ]; then
  . /usr/local/etc/bash_completion.d/git-flow-completion.bash
fi


## add bin dirs
bin=$HOME/bin
mac_bin=$HOME/data/settings/daveconfig/mac/bin
PATH=$bin:$mac_bin:$PATH
export PATH

# Use brew versions of applications.
export PATH="/usr/local/bin:$PATH"
# Machine-specific apps
export PATH="~/local/bin:$PATH"
#~ export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# On mac, packages are installed here
export PATH="$HOME/Library/Python/3.9/bin:$PATH"


if [ -x /usr/local/bin/python3 ] && [ ! -f /usr/local/bin/python ]; then
    # brew installs python3 but doesn't link it.
    echo Creating symlinks to make python3 the default python.
    ln -s /usr/local/bin/python3 /usr/local/bin/python
    ln -s /usr/local/bin/pydoc3 /usr/local/bin/pydoc
fi


# For compilers to find ruby you may need to set:
#   export LDFLAGS="-L/usr/local/opt/ruby/lib"
#   export CPPFLAGS="-I/usr/local/opt/ruby/include"
# For compilers to find python@3.9 you may need to set:
#   export LDFLAGS="-L/usr/local/opt/python@3.9/lib"

if [[ $SHLVL -eq 1 ]] && [[ -z "$VIMRUNTIME" ]]; then
    # we invoked from a Terminal window, not somewhere else. Vim's background
    # shell seems to invoke as interactive, so check for its environment
    # variable.
    # This is really slow :(
    /usr/bin/osascript ~/data/settings/daveconfig/mac/terminal/RandomColorTerminal.applescript
fi

# macOS Terminal inserts control codes for Ctrl-left/right instead of doing
# anything. begin/end of line is consistent with the rest of macOS, but
# probably what I intended was Alt-left/right. Be consistent.
# https://rakhesh.com/mac/macos-terminal-make-ctrl-left-go-to-beginning-of-the-line/
bind '"\033[1;5D": beginning-of-line'
bind '"\033[1;5C": end-of-line'
