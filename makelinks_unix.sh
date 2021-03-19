#! /bin/bash

dconfig_path=~/data/settings/daveconfig

ln -s --no-target-directory $dconfig_path/multi/vim ~/.vim
ln -s $dconfig_path/multi/vim/vimrc.vim ~/.vimrc
ln -s $dconfig_path/multi/vim/gvimrc.vim ~/.gvimrc

ln -s $dconfig_path/multi/git/.gitconfig ~/.
ln -s $dconfig_path/multi/git/.gitignore ~/.

ln -s $dconfig_path/multi/zbstudio ~/.zbstudio

config_dir=$dconfig_path/unix/terminal/
for a in `find $config_dir -maxdepth 1 -type f` ;do
    ln -s $a ~/.$(basename $a)
done

if [[ -d $dconfig_path/multi/vim/bundle/work/scripts/bin ]] && [[ ! -e ~/bin ]]; then
    echo "Linking ~/bin"
    ln -s $dconfig_path/multi/vim/bundle/work/scripts/bin ~/bin
fi

# Should these be in bin or PATH?
#ln -s --target-directory=$HOME/data/apps/bin/ $dconfig_path/multi/git/submanage/git-*
#ln -s --target-directory=$HOME/data/apps/bin/ $dconfig_path/multi/git/tool/*.git.sh

# bashrc is different on different platforms
function delete_if_symbolic {
    file=$1
    if [ -L $file ] ; then
        rm $file
    fi
}
if [ `uname` = 'Linux' ] ; then
    # linux uses bashrc, get rid of the profile or it will interfere
    # mac uses profile and bashrc
    delete_if_symbolic ~/.profile
fi

if [[ -r /proc/version ]]; then
    if grep --quiet --max-count=1 Microsoft /proc/version; then
        ln -s $dconfig_path/multi/git/wsl.gitconfig.local ~/.gitconfig.local
    fi
fi



