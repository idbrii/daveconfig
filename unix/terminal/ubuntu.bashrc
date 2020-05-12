#! /bin/bash
#
# bashrc for Ubuntu
#

## Environment Settings {{{1
export ANDROID_HOME=$HOME/data/.android_devkit/android-sdk-linux

export ECLIM_ECLIPSE_HOME=$HOME/data/apps/eclipse

# Set our primary development gpg key to be default
export GPGKEY=D4D6822E

# Pointer to the previous Ubuntu install
export OTHER_HOME=/media/bork$HOME
if [ ! -d $OTHER_HOME ] ; then
    export OTHER_HOME=/media/munge$HOME
fi

export PATH=$PATH:~/data/apps/bin

if [[ -r /proc/version ]]; then
    if grep --quiet --max-count=1 Microsoft /proc/version; then
        # WSL adds Windows paths in PATH, but these are substitutes for unix
        # commands.
        REMOVE='/mnt/c/david/settings/daveconfig/win/system/bin'
        export PATH=${PATH/:$REMOVE:/:}
    fi
fi



## Commands {{{1

# To disable the package lookup, use this code:
#~ function command_not_found_handle {
#~     echo Command not found: $1
#~     return 127
#~ }


## Abort if not interactive or not smart {{{1
# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# If using a dumb terminal like vim's :shell, then don't do anything.
[ "$TERM" == "dumb" ] && return


## Fancy Colours {{{1
# You need to install ncurses-term for this to work.
# Automatically set the TERM correctly for xterm
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi

# Provide fallbacks if there are missing Terminfo files:
SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi

# vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
