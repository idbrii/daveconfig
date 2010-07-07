# Creating to work with GNU bash, version 2.05b.0(1)-release (powerpc-apple-darwin8.0)
# 26 Dec 2008

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# ls
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -A'
alias les='/usr/share/vim/vim71/macros/less.sh'

# aptitude
alias aptinstall='sudo aptitude install'
alias aptremove='sudo aptitude remove'
alias aptautoremove='sudo apt-get autoremove'   # no autoremove for aptitude
alias aptsearch='apt-cache search'
alias aptshow='apt-cache show'

# windows work-alike
alias cls='clear'
alias tracert='tracepath'

# python
alias ipy='ipython'

# Advanced applications
# unfortunately, this is Mac-specific. Ideally, I'd use $VIMRUNTIME
# currently doesn't work alias les='/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'


alias butter='ssh flutterbutter.local'


# Quick way to view files in vim
function v { $* | view - ; }

