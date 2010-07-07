#! /bin/sh

dconfig_path=~/data/settings/daveconfig

ln -s $dconfig_path/multi/vim/.vim ~/.
ln -s $dconfig_path/multi/vim/.vimrc ~/.
ln -s $dconfig_path/multi/vim/.gvimrc ~/.

ln -s $dconfig_path/multi/git/.gitconfig ~/.
ln -s $dconfig_path/multi/git/.gitignore ~/.

ln -s $dconfig_path/unix/bash/.bash_aliases ~/.
# bashrc is different on different platforms
if [ `uname` = 'Linux' ] ; then
    ln -s $dconfig_path/unix/bash/.bashrc ~/.
else
    # if mac
    ln -s $dconfig_path/unix/bash/.profile ~/.
fi

