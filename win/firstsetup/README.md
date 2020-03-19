Installation
============

use scoop.sh:

    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop install
        7zip
        autohotkey
        flux
        git
        imageglass
        love
        paint.net
        python
        ripgrep
        sudo
        universal-ctags
        vim-nightly
        workrave
    sudo scoop install firacode firamono-nf ProggyClean-NF

Possibly also:

    scoop install
        slack
        tortoisesvn


But do the workaround here for gvim: https://github.com/ScoopInstaller/Main/issues/848

Windows
=======

## Dark mode

Turn it on in settings.

Fix white line in File Explorer.
Open File Explorer -> Right click the Title bar -> Check Lock the toolbars. Try open File Explorer again.


## Differentiate active window
Personalization (Themes) > Colors > Title bars

Settings > Search > snap
"When I snap a window, show what I can snap next to it"


vim
===

Copy vim-cache, vim-aside, and todo.org to new machine.


unix
====

Setup Bash on Windows: https://msdn.microsoft.com/en-us/commandline/wsl/install_guide

Launch ubuntu
Right click top left icon
Defaults
Turn on "Use Ctrl+Shift+C/V"
Turn off insert mode and ctrl key shortcuts

In Colors, change the second blue to 77,77,255 to make it legible. Be sure to click black again before OK! (Do I still need to do this?)


Office ALL CAPS menus
=====================
Run FixCasing batch file from: http://superuser.com/questions/493836/how-do-i-get-rid-of-all-caps-ribbon-titles-in-office-2013


Visual Studio ALL CAPS menus
=====================
Use `VisualStudio_SentenceCaseMenus.reg` for VS2012.

http://stackoverflow.com/questions/10859173/how-to-disable-all-caps-menu-titles-in-visual-studio


Window Borders
==============
You should export WindowMetrics to WindowMetrics.original.reg before running.

Use `Windows_ThinWindowBorders.reg`

http://superuser.com/a/461983/11808


Paint.Net
=========

[Paint.Net](http://www.getpaint.net/index.html) is a free improvement over mspaint that isn't as complex as Photoshop. Use `Windows_OpenWithPaintNet.reg` to change your "Edit" menu on images to use Paint.Net.

Evoluent Vertical Mouse
=======================

Turn off "accelerated scrolling" in the Evoluent Vertical Mouse wheel settings.
https://connect.microsoft.com/VisualStudio/feedback/details/870717/evoluent-mouse-manager-4-crashes-with-visual-studio-2013-update-2-rc

sandbox
=======

Copy the sandbox folder to c:\sandbox.
Copy the comment from the top of ideone.cpp to any cpp in the sandbox to make it easy to execute.

AutoHotKey
==========

Right click, Compile ActiveWindowInfo.ahk and rename exe to AU3_Spy.exe because it's missing from the zip.


Software
========

## Flux - tint screen at night
https://justgetflux.com/
Make sure to disable hotkeys.


## Fonts

Proggy Clean (for size 12):
www.proggyfonts.net/download/

Fira Mono (for different sizes):
https://github.com/mozilla/Fira/releases

