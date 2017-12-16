#! /bin/bash


# https://brew.sh/
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# latest git comes with git-completion!
brew install wget bash-completion git

# automatically installs cask
# install unity
brew cask install unity
brew cask install google-chrome
