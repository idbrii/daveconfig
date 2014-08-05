daveconfig
==========

daveconfig is a collection of my various settings for different environment

Be aware that I use this repo as a way to share my settings between home and work and anywhere else, so not everything is necessarily stable.


Great Renaming
==============

I used to use daveconfig/multi/vim/.vim/ but the .vim in there is pointless. I
tried moving everything, but that makes it harder to use filter-branch to
extract plugins with full history (since they moved. I've used filter-branch to
rewrite history so it's as if .vim was never there (and everything was always
just in) daveconfig/multi/vim/.

To update a clone of daveconfig with local changes, you reset to github's
master and cherry-pick your changes. (Rebasing will apply duplicates of all the
old commts.) Note that `tac` to ensure the commits are applied in the correct
order.

The commit adding these instructions doesn't exist in mainline, but I don't
know how to remove it. Just rebase and delete it yourself.

::

	git branch old-tip
	git reset --hard github/master
	for commit in `git log --pretty="%H" github/old-master-before-great-renaming...old-tip | tac` ; do git cherry-pick $commit ; done
    # Remove first cherry-picked commit


environment
===========

I switch a lot between Ubuntu and Windows and I try to keep everything working consistently between them. This repo is generally checked out to ~/data/settings/daveconfig and that path is hardcoded in several places.


vim
===

Vim is the most active section of this repo. Here are some basics about how I use vim that might help you determine if you'd want to try some of my settings:

- Visual mode is my counter. I rarely use counts for arguments and I don't find tools like EasyMotion useful. They don't fit with my brain. Instead, I enter visual mode, define the region I want to operate on, and go.
- I don't use tabs. I use BufExplorer and Ctrlp to navigate between buffers and I don't find having a visual indicator of my current open tabs useful. If I wanted that, I'd open BufExplorer and search the output. I use splits when I am frequently jumping between on multiple files.
- I write a lot of my own plugins, and I fail at maintaining a stable branch. Eventually, I'll switch everything so my branch is a dev branch that I am occasionally syncing master to.
- I want my vim to start as fast as possible, so I love autoload (where applicable).


terminal
========

I use bash and like to be in the terminal a lot. I use cygwin on windows.

