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
packages="$packages python python3"
packages="$packages luarocks"
packages="$packages cscope ctags"
packages="$packages opensharp-mono"
# Markdown preview
packages="$packages pandoc"
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

# I think I need to do this?
brew unlink vim

# gamedev
brew cask install steam

brew tap wooga/unityversions
brew cask install unity@version_here


# Lua/Love
luarocks install love

brew install openssl
luarocks install loverboy CRYPTO_DIR=/usr/local/opt/openssl/ OPENSSL_DIR=/usr/local/opt/openssl

brew install libzip
brew install p7zip
#~ luarocks install lua-zip ZIP_DIR=/usr/local
luarocks install --server=http://luarocks.org/dev lua-lsp ZIP_DIR=/usr/local

luarocks install luacheck
luarocks install penlight
# Can't -- version of love is too new for imgui
#~ luarocks --server=http://luarocks.org/dev --lua-dir=/usr/local/opt/lua@5.1 install love-imgui


echo "Get NTFS driver for mac for Seagate drives: https://www.seagate.com/ca/en/support/downloads/item/ntfs-driver-for-mac-os-master-dl/"
