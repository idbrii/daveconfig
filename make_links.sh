ln -s ~/data/settings/daveconfig/multi/vim/.vim ~/.
ln -s ~/data/settings/daveconfig/multi/vim/.vimrc ~/.
ln -s ~/data/settings/daveconfig/multi/vim/.gvimrc ~/.

ln -s ~/data/settings/daveconfig/multi/git/.gitconfig ~/.
ln -s ~/data/settings/daveconfig/multi/git/.gitignore ~/.

ln -s ~/data/settings/daveconfig/unix/bash/.bash_aliases ~/.
if [ `uname` = 'Linux' ] ; then
    ln -s ~/data/settings/daveconfig/unix/bash/.bashrc ~/.
else
    # if mac
    ln -s ~/data/settings/daveconfig/unix/bash/.profile ~/.
fi
