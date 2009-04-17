if [ "`uname -s`" == "Darwin" ] ; then
    # on a mac
    ctags -R -f ~/.vim/tags/python.ctags /opt/local/lib/python2.5/
else
    # elsewhere (probably Linux)
    ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python2.5/
fi
