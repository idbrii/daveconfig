## bashrc for Mac OSX

# This is the .bashrc from git. Modified for my ubuntu
# lines with ## are my changes (for ubuntu and mac)
# Last update:

# ~/.bashrc: executed by bash(1) for non-login shells.


## Used by mail and other programs that invoke your favourite editor.
VISUAL=vim
export VISUAL
## comment this if the above isn't really is your favourite editor
EDITOR="$VISUAL"
export EDITOR
PAGER=less
export PAGER

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Alias definitions.
##My additions are in into a separate file: ~/.bash_aliases
##instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Don't blindly execute history
shopt -s histverify

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
# note that linux uses xterm even though it supports colour!
case "$TERM" in
xterm*)
    PS1='\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1='\[\033[01;30m\]\h\[\033[00m\]:\[\033[01;38m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1='\u@\h:\w\$ '
    ;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}: ${PWD/$HOME/~}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac


## enable vim-like syntax
#set -o vi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
		else
		   return 127
		fi
	}
fi

export ECLIM_ECLIPSE_HOME=/home/$USER/data/apps/eclipse

export CLASSPATH=/usr/share/java/clojure.jar:$HOME/.clojure-vim/clojure-contrib.jar:$HOME/.clojure-vim/clojure-contrib-slim.jar:$HOME/.clojure-vim/vimclojure.jar:$HOME/.clojure-vim/vimclojure-source.jar
