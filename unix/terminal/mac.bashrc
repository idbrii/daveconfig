## bashrc for Mac OSX

# This is the .bashrc from kalos. Modified for my mac (now it's .profile)
# lines with ## are my changes (for ubuntu and mac)
# Last update:
# Tue Feb 26 11:18:54 EST 2008

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


## Used by mail and other programs that invoke your favourite editor.
VISUAL=vim
export VISUAL
## comment this if the above isn't really is your favourite editor
EDITOR="$VISUAL"
export EDITOR
PAGER=less
export PAGER


# Alias definitions.
##My additions are in into a separate file: ~/.bash_aliases
##instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# We failed to load bash_completion in unix.bashrc because homebrew installs to /usr/local. Use brew to find the right spot.
# Source: https://github.com/bobthecow/git-flow-completion/issues/46#issuecomment-332724240
# Dropped
# https://github.com/bobthecow/git-flow-completion/blob/master/git-flow-completion.bash
# into completion dir.
# Linked git completion:
# ln -s /usr/local/git/contrib/completion/git-completion.bash /usr/local/etc/bash_completion.d/git-completion.bash
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
fi
if [ -f `brew --prefix`/etc/bash_completion.d/git-flow-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-flow-completion.bash
fi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

##set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
PS1='\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PS1='\[\033[01;30m\]\h\[\033[00m\]:\[\033[01;38m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='\u@\h:\w\$ '
    ;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

## enable vim-like syntax
#set -o vi

# Setting PATH for MacPython 2.4
#python_bin="/Library/Frameworks/Python.framework/Versions/Current/bin"

## add bin
bin=/Users/dbriscoe/bin
#PATH=$bin:$python_bin:$PATH
PATH=$bin:$PATH
# (mac only) Setting the path for MacPorts.
#PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH

if [ $SHLVL -eq 1 ]; then
    # we invoked from a Terminal window, not somewhere else.
    # note that this is really slow :(
    osascript ~/data/settings/daveconfig/mac/terminal/RandomColorTerminal.scpt
fi

