#! /bin/bash
#
# bashrc for Unix-like systems
#


## Used by mail and other programs that invoke your favourite editor.
export VISUAL=vim
## comment this if the above isn't really is your favourite editor
export EDITOR="$VISUAL"
export PAGER=less

# Path extensions
export PATH=$PATH:~/data/settings/daveconfig/multi/git/submanage:~/data/settings/daveconfig/multi/git/tool:~/data/settings/daveconfig/unix/bin:~/.local/bin/

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Command to allow special windows behaviour (mostly for ubuntu, but I want it
# available for aliases too).
is_windows()
{
	grep --quiet --no-messages --max-count=1 Microsoft /proc/version
}

# If using a dumb terminal like vim's :shell, then don't do anything (since I
# use ls --color=auto as an alias)
[ "$TERM" == "dumb" ] && return

##My additions are in into a separate file: ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

case "`uname -s`" in
MINGW*)
    # mingw doesn't have stty.exe
    ;;
*)
    # Allow block select in terminal vim.
    # Don't use Ctrl-q as resume: http://stackoverflow.com/a/7884226/79125
    stty -ixon

    # Don't break my terminal (Ctrl-S should be save!)
    stty start ""
    stty stop ""
    ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# Don't blindly execute history
shopt -s histverify

# Make **/*.py search recursively if bash is new enough (it's not on macOS).
if [[ $BASH_VERSION == 4.* ]]; then
    shopt -s globstar
fi

# Bigger history. Seems to automatically get sync'd with HISTFILESIZE.
export HISTSIZE=100000

# Don't store these little commands
export HISTIGNORE="&:ls:[bf]g:exit"

# Bashmarks provides bookmarking in bash
export SDIRS=~/data/settings/daveconfig/unix/terminal/bashmarks.sdirs
source ~/data/settings/daveconfig/unix/terminal/bashmarks/bashmarks.sh

# Use scons in quiet mode
export SCONSFLAGS=-Q


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
# note that linux uses xterm even though it supports colour!
case "$TERM" in
    # HEY! If the PWD on Bash on Windows looks bad, follow my firstsetup instructions!
#~ xterm-256color)
#~     # [cyan]hostname:[grey]path
#~     PS1='\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\030[00m\]\$ '
#~     ;;
xterm*)
    # [cyan]hostname:[blue]path
    PS1='\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # [grey]hostname:[white]path
    #PS1='\[\033[01;30m\]\h\[\033[00m\]:\[\033[01;38m\]\w\[\033[00m\]\$ '
    ;;
dumb)
    # Don't do anything for a dumb terminal -- like :shell in vim
    ;;
screen*)
    # [cyan]hostname:[blue]path
    # put square brackets around hostname to indicate a screen session
    PS1='\[\033[01;36m\][\h]\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1='\u@\h:\w\$ '
    ;;
esac

# If this is an xterm set the title to user@host:dir
function build_prompt_command
{
    p_user=$1
    p_host=$2
    # Put the user and host as requested. Add the current dir using ~ if
    # applicable, but only if it's home (not somewhere else with
    # /.../home/user)
    echo 'echo -ne "\033]0;'$p_user'@'$p_host': ${PWD/#$HOME/~}\007"'
}
case "$TERM" in
xterm*|rxvt*)
    # Shorten the user and hostname to the first character since generally
    # that's enough to tell them apart.
#    PROMPT_COMMAND=`build_prompt_command ${USER} ${HOSTNAME}`
    PROMPT_COMMAND=`build_prompt_command ${USER::1} ${HOSTNAME::1}`
    ;;
screen*)
    # put square brackets around hostname to indicate a screen session
    PROMPT_COMMAND=`build_prompt_command ${USER::1} [${HOSTNAME::1}]`
    ;;
dumb)
    # Don't do anything for a dumb terminal -- like :shell in vim
    ;;
*)
    ;;
esac

## enable vim-like syntax
#set -o vi
