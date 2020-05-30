#! /bin/bash


# https://brew.sh/
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Brew needs code tools.
xcode-select --install

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
packages="$packages python3"
packages="$packages luarocks"
packages="$packages cscope"
# Installs as gsed, but we put a shim in our path
packages="$packages gnu-sed"
# Markdown preview
packages="$packages pandoc"
# TODO: Which one to use:
packages="$packages macvim"
casks="$casks vimr"
pip3 install neovim

#
# work
packages="$packages subversion"
casks="$casks macpass"

brew install $packages


# No stable universal-ctags yet.
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# using cask automatically installs it

brew cask install google-chrome

# make window fill half screen with keyboard
brew cask install spectacle

# Map Cmd-1,3,4 to Vim,Terminal,Chrome
brew cask install apptivate

# I don't think I really have much use for this. I don't even remember why I
# installed it. It's useful to make CapsLock into Cmd or to get mac Fn keys on
# external keyboard, but those aren't very attractive.
#~ brew cask install karabiner-elements

# Make scroll wheel behave like Windows.
brew cask install scroll-reverser

# Support back/forward buttons on external mice
brew cask install sensiblesidebuttons

# I think I need to do this?
brew unlink vim

# gamedev
brew cask install steam

brew tap wooga/unityversions
# TODO: Must change this version!!!
brew cask install unity@version_here


# Lua/Love
luarocks install love

brew install libzip
brew install p7zip
#~ luarocks install lua-zip ZIP_DIR=/usr/local
luarocks install --server=http://luarocks.org/dev lua-lsp ZIP_DIR=/usr/local

luarocks install luacheck
luarocks install penlight
# Can't -- version of love is too new for imgui
#~ luarocks --server=http://luarocks.org/dev --lua-dir=/usr/local/opt/lua@5.1 install love-imgui


echo "Get NTFS driver for mac for Seagate drives: https://www.seagate.com/ca/en/support/downloads/item/ntfs-driver-for-mac-os-master-dl/"
