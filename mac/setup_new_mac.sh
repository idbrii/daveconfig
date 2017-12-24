#! /bin/bash


# https://brew.sh/
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

packages=
casks=


#
# terminal basics
packages="$packages wget"
# latest git comes with git-completion!
packages="$packages bash-completion git"

#
# vim
# install my own python for pip
packages="$packages python"
packages="$packages cscope ctags"
packages="$packages opensharp-mono"
# TODO: Which one to use:
packages="$packages macvim"
casks="$casks vimr"
pip2 install neovim

#
# work
packages="$packages subversion"
casks="$casks macpass"

brew install $packages


# Special case to avoid gsed
brew install --with-default-names gnu-sed

# using cask automatically installs it

brew cask install google-chrome

# make window fill half screen with keyboard
brew cask install spectacle

# gamedev
brew cask install unity steam

