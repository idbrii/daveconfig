#! /bin/sh

# TODO: Setup for gnome-shell instead of ubuntu-unity.

small='true'
#~ small='false'

if [ ! -e ~/.done_setup_new_ubuntu ] ; then
# Settings {{{
    mkdir -p ~/.local/share/applications
    
    settings_path=~/data/settings
    
    # Pull in settings
    bash $settings_path/link_dotfiles.sh
    bash $settings_path/link_firefox.sh
    bash $settings_path/link_otherconf.sh
    bash $settings_path/link_menuitems.sh
    bash $settings_path/daveconfig/makelinks_unix.sh
    
    # nautilus scripts
    cd $settings_path/daveconfig/unix/nautilus
    bash $settings_path/daveconfig/unix/nautilus/copy_files.sh
    cd -
# }}}
fi

if [ ! -e ~/.done_setup_new_ubuntu ] ; then

    # The last time we'll use apt directly.
    sudo apt-get install -y aptitude

    # Enable disabled remote repos. I usually run with all of them on
    # In precise, this enables partner.
    sudo sed -i.backup -e"s/^# \(deb http\)/\1/" /etc/apt/sources.list

# Add repositories {{{1
# use nautilus-elementary. (changes the version of nautilus used)
#sudo add-apt-repository ppa:am-monkeyd/nautilus-elementary-ppa

# ubuntu-tweak from developer's ppa
#sudo add-apt-repository ppa:tualatrix/ppa

# handbrake from dev ppa
#sudo add-apt-repository ppa:stebbins/handbrake-releases
# For oneiric, I needed to use handbrake-snapshots because there weren't any oneiric releases yet. I should remove that when releases has a release.

# Add Faenza icons ppa
#   http://gnome-look.org/content/show.php?content=128143&vote=good&tan=74596018
#sudo add-apt-repository ppa:tiheum/equinox

# Typing break - I use workrave instead
#sudo add-apt-repository ppa:drwright/stable
# }}}
fi

sudo aptitude update

if [ ! -e ~/.done_setup_new_ubuntu ] ; then
# Remove Junk Programs {{{1
# For some reason, you have to remove several packages to completely get rid of openoffice
office="evolution libreoffice libreoffice-core libreoffice-l10n-en-gb libreoffice-l10n-en-za"
scopes="unity-scope-virtualbox unity-scope-gourmet unity-scope-colourlovers unity-scope-yelp unity-scope-musicstores unity-scope-musique unity-scope-audacious unity-scope-gmusicbrowser unity-scope-guayadeque unity-scope-clementine unity-scope-tomboy unity-scope-texdoc unity-scope-openclipart unity-scope-video-remote unity-scope-devhelp unity-scope-gdrive unity-scope-chromiumbookmarks unity-scope-firefoxbookmarks unity-scope-zotero unity-scope-manpages"
sudo aptitude -y remove --purge $office $scopes
sudo aptitude -y autoclean
# }}}
fi

# Installing Programs {{{1
# I want to categorize the programs, but I need them all in one apt command so
# it doesn't ask for root permission again, so we build up a big command.
programs=""

# [off] Hardware {{{2
# Support for HL-2040. See https://wiki.ubuntu.com/BrotherDriverPackaging
programs="$programs brother-cups-wrapper-laser"

# [off] Work -- VPN {{{2
#programs="$programs vpnc network-manager-vpnc-gnome"
# }}}
# [off] Netbook theme and desktop magic {{{2
#       go-home-applet is optional
#programs="$programs netbook-launcher-efl netbook-launcher go-home-applet human-netbook-theme maximus window-picker-applet wmctrl"
#programs="$programs wmctrl"

# Applications {{{2
#programs="$programs gnome-do gnome-do-plugins"
programs="$programs abiword gnumeric speedcrunch gimp inkscape pitivi calibre"
# Fun with Math
programs="$programs geogebra"

# Old motorola phone
#programs="$programs moto4lin " #gmobilemedia "
# }}}

# Games {{{2
    programs="$programs steam playonlinux wine gnotravex scummvm"
    # controller support
    programs="$programs wminput"
    # free games
    programs="$programs beneath-a-steel-sky flight-of-the-amazon-queen"
    # open source games
    #programs="$programs spring-mods-kernelpanic glob2 hedgewars freealchemist frozen-bubble teeworlds "
    #programs="$programs glest warsow freedroid freedroidrpg "

# Small install only includes the packages below.
if [ $small == "true" ] ; then
    programs=""
fi

# Code {{{2
    programs="$programs build-essential scons cmake exuberant-ctags cscope meld git giggle mercurial mercurial-git ipython screen"
    # Python refactoring
    programs="$programs python-rope bicyclerepair"

    # Python
    programs="$programs python-pip python-optcomplete python-docutils"

# Can install one of these jre source packages to prevent eclim from
# complaining about missing src.zip
# programs="$programs openjdk-6-source sun-java6-source"

# Primary {{{2
    # from ppas
    programs="$programs ubuntu-tweak handbrake-gtk faenza-icon-theme" # requires ppa
    
    # Essential
    programs="$programs vim-gnome chromium-browser pepperflashplugin-nonfree openssh-server"
    # Media
    programs="$programs cheese vlc moovida"
    #programs="$programs banshee"
    # Tweaks/codecs
    programs="$programs apt-file nautilus-open-terminal ncurses-term libdvdread4 gparted ubuntu-restricted-extras compizconfig-settings-manager compiz-plugins-extra xdotool wmctrl dconf-tools workrave"
    # Need libdvdcss libdvdread4 libdvdnav4?
    # Fix chromium videos: http://askubuntu.com/a/390187/9411 http://askubuntu.com/a/378182
    programs="$programs chromium-codecs-ffmpeg-extra"
    
    # Tools
    programs="$programs p7zip lame"

    # Some of these don't come with a server install? (Or maybe this list came from cygwin.)
    programs="$programs bash bash-completion binutils bzip2 coreutils cscope ctags curl diffutils dos2unix findutils git git-completion grep gzip indent less openssh sed subversion universal-ctags"

# I use parcellite as a workaround for a bug in chromium:
#   http://code.google.com/p/chromium/issues/detail?id=67074
#programs="$programs parcellite"

# }}}

sudo aptitude install -y $programs

# Installing Python Packages {{{1
# Development tool packages -- for deployed packages, I should use virtualenv.
packages="ropevim pycscope virtualenv"
sudo pip install $packages
# }}}

if [ ! -e ~/.done_setup_new_ubuntu ] ; then
    echo
# Post-install {{{1

    # TODO: migrate windowbindings to gsettings
    #sh gconf_windowbindings.sh
    #sh gconf_gnometweaks.sh
# }}}
fi

# Manual setup instructions {{{1
# TODO:
# gconf-editor changes. how to port settings:
#       meld $OTHER_HOME/.gconf/apps/ /home/dbriscoe/.gconf/apps/
#   get panel objects
#       meld $OTHER_HOME/.gconf/apps/panel/objects/ ~/.gconf/apps/panel/objects/
#   get menu entries (according to http://library.gnome.org/admin/system-admin-guide/2.20/menustructure-13.html.en)
#       meld $OTHER_HOME/.config/menus/applications.menu ~/.config/menus/applications.menu
#       
# clean grub
# 

# Gnome-shell
echo Install these extensions for gnome-shell
gogo https://extensions.gnome.org/extension/39/put-windows/
gogo https://extensions.gnome.org/extension/413/dash-hotkeys/

# Vim
# Comment out 'syntax on' in /etc/vim/vimrc

# Clojure (and vimclojure)
#   aptinstall leiningen
#   lein plugin install lein-tarsier 0.9.1
# Setup vim-clojure client:
#   cd ~/.vim/bundle/clojure/
#   git checkout stable
#   ./update_to_latest_version


# Manual operations:
# Disable online search in dash:
#   System Settings > Security & Privacy > Search
#
# Disks -- name otheros partition
#
# grub -- reduce startup delay
#   gvim /etc/default/grub
#   change GRUB_TIMEOUT from 10 to 1
#   sudo update-grub
#   See also https://help.ubuntu.com/community/Grub2
# 
# Add ~/data/settings/menuitems/ to menu
#
# Add google repos:
#   http://www.google.com/linuxrepositories
#
# Copy game scores:
#   sudo cp -f /media/*/var/games/* /var/games/.

# Setup dvd playback (see https://help.ubuntu.com/community/RestrictedFormats/PlayingDVDs):
#  sudo /usr/share/doc/libdvdread4/install-css.sh

# Rename wired connection to hardlink
#   Network manager > Edit connections

# Fix name of wireless interface (from eth2 to wlan1):
#   http://ubuntuforums.org/showthread.php?t=1654349
#   Edit /etc/udev/rules.d/70-persistent-net.rules
#
# }}}

# Signal that we shouldn't do most of the common one-time setup tasks.
# (Generally, this whole thing is a one-time setup, but it's good to test the
# app installing.)
touch ~/.done_setup_new_ubuntu


# vim: set fdm=marker :
