daveconfig
==========

daveconfig is a collection of my various settings for different environment

Not everything is contained here; I'm using submodules, so be sure to run this after your clone:

    git submodule update --init


Sometimes I change the url for a repo (switching from maintainer to me). Try this to fix git pull errors about shas not being a tree:

    git submodule sync

If you are going to modify a submodule, be sure to check out a branch first! (You're on no branch by default.)


Be aware that I use this repo as a way to share my settings between home and work and anywhere else, so not everything is necessarily stable.


environment
===========

I switch a lot between Ubuntu and Windows and I try to keep everything working consistently between them. This repo is generally checked out to ~/data/settings/daveconfig and that path is hardcoded in several places.


vim
===

Vim is the most active section of this repo. Here are some basics about how I use vim that might help you determine if you'd want to try some of my settings:

- Visual mode is my counter. I rarely use counts for arguments and I don't find tools like EasyMotion useful. They don't fit with my brain. Instead, I enter visual mode, define the region I want to operate on, and go.
- I don't often use tabs. I use Unite to navigate between buffers and I don't find having a visual indicator of my current open tabs useful. If I wanted that, I'd open `:Unite buffer` and filter the output. I use splits when I am frequently jumping between on multiple files. I limit use of tabs when opening a new set of files to work with or to get a fullsize view of my current file without changing my window layout.
- I write a lot of my own plugins, but only sometimes put experimental work in a dev branch that I am occasionally merge to master.
- I want my vim to start as fast as possible, so I love autoload (where applicable).


terminal
========

I use bash and like to be in the terminal a lot. I use WSL on windows.


Cloning on Windows with WSL
===========================

* Use WSL1 for faster access between linux <-> ntfs.
* Clone daveconfig onto windows filesystem from Linux.
    * Don't want two separate trees to maintain.
    * Checkout from Linux so line endings are Unix (and unix scripts don't fail).

```bash
    mkdir -p /mnt/c/david/settings
    ln -s /mnt/c/david ~/data
    cd ~/data/settings
    git clone git@github.com:idbrii/daveconfig.git
    cd daveconfig
    git manage-mine master

    # WSL comes with a bashrc. Move to allow symlink creation.
    mkdir ~/junk
    mv ~/.bash* ~/junk
    ./makelinks_unix.sh 

    # Now that our gitconfig is setup, update our submodules.
    git submodule update --init
```

Then run makelinks_win.cmd as admin.

