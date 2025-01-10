Installation
============

use scoop.sh:

    scoop bucket add extras
    scoop bucket add versions
    scoop bucket add nerd-fonts
    scoop install
        7zip
        alacritty
        autohotkey
        ffmpeg
        flux
        git
        imageglass
        love
        paint.net
        pandoc
        powertoys
        python310
        ripgrep
        screentogif
        stretchly
        sudo
        sysinternals
        treesize-free
        universal-ctags
        vim-nightly
        vlc
    sudo scoop install firacode firamono-nf ProggyClean-NF

Possibly also:

    scoop install
        git-credential-manager
        llvm
        renderdoc
        slack
        tightvnc
        tortoisesvn
        vscode

    sudo scoop install
        FiraCode@1.207

(firacode 2 has ligatures for all kinds of things and not just symbols)

pip:

    pip install
        ahk
        keyboard


* Do the workaround for gvim: https://github.com/ScoopInstaller/Main/issues/848
* Run the .reg for python (scoop info python)
* Run stretchly, setup timers, enable run on startup
* Run imageglass and enable file association
* Run flux; add shortcut to startup menu
* Clean up context menus (below)
* Install Win64 and Linux versions of [gtm](https://github.com/git-time-metric/gtm/releases/) to %USERPROFILE%\AppData\Local\Microsoft\WindowsApps and ~/apps/bin
    * WindowsApps is already in the PATH.
* If using C#, do :OmniSharpOpenLog and install the .NET Framework Developer Pack it complains about. If there are still errors, [install a recent MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/walkthrough-using-msbuild?view=vs-2019#install-msbuild).
* Install [vimproc](https://github.com/Shougo/vimproc.vim/releases/) to ~/.vim/bundle/vimproc/lib/ for unite and open-browser.
* Install WSL (below)
* Install Lua (below)
* Add ../../multi/svn/config to global svn config.
* Create shortcuts to terminal apps in alacritty to get unique taskbar icons in win11.
    %USERPROFILE%\scoop\shims\alacritty.exe -e C:\bin\run_win11.bat

Windows
=======

# PATH

Add some paths to PATH:

    %USERPROFILE%\scoop\apps\tortoisesvn\current\bin
    C:\david\apps\bin
    C:\david\settings\daveconfig\win\system\bin
    C:\david\settings\daveconfig\win\visualstudio\vcvars

(scoop doesn't add tortoisesvn to path itself.)

## WSL

* [Enable the windows subsystem for linux](https://docs.microsoft.com/en-ca/windows/wsl/install-win10#step-1---enable-the-windows-subsystem-for-linux)
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
* Skip WSL2 -- I don't want a segregated linux install. I use linux to process files on Windows.
* Install Ubuntu from Windows Store
* [Generate a new ssh key and add to github](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


## Context Menus

Remove 'Edit with 3D paint' and 'Edit with photos':
https://www.windowscentral.com/how-remove-edit-photos-and-edit-paint-3d-context-menu-windows-10

Run Windows_OpenWithPaintNet.reg to make paint.net (via scoop) the default image editor.


## Dark mode

Turn it on in settings.


## Differentiate active window

Personalization (Themes) > Colors > Title bars

Settings > Search > snap
"When I snap a window, show what I can snap next to it"


## Startup

Create shortcuts in `shell:startup`:

* AutoHotkey.ahk
* vide.cmd


## python

Turn off python in Manage App Execution Aliases.
[To prevent 'python' from opening Windows Store](https://stackoverflow.com/questions/58754860/cmd-opens-window-store-when-i-type-python)


When running python installed via scoop it does not configure the user or system level association.


Using `assoc` doesn't seem to work (python_assoc.cmd).

Edit the registry and add %* to py_auto_type as described [in this answer](https://superuser.com/a/669154).

vim
===

Copy vim-cache, vim-aside, and plan.md to new machine.


lua
===

* ~/.vim/bundle/lua-david/lib/readme.md
* For luarocks download hererocks with

```
    wget https://raw.githubusercontent.com/mpeterv/hererocks/latest/hererocks.py
    python hererocks.py --lua 5.4 -r latest
```


unix
====

Setup Bash on Windows: https://msdn.microsoft.com/en-us/commandline/wsl/install_guide

Launch ubuntu
Right click top left icon
Defaults
Turn on "Use Ctrl+Shift+C/V"
Turn off insert mode and ctrl key shortcuts
Change font to Fira Code and size to 14
    * makes gtm report display properly

In Colors, change the second blue to 77,77,255 to make it legible. Be sure to click black again before OK! (Do I still need to do this?)

Fix [errors setting permissions](https://stackoverflow.com/questions/52846489/cant-clone-repository-from-mounted-drive#), if applicable.

Run ~/data/settings/daveconfig/unix/setup_new_ubuntu.sh


Office ALL CAPS menus
=====================
Run FixCasing batch file from: http://superuser.com/questions/493836/how-do-i-get-rid-of-all-caps-ribbon-titles-in-office-2013


Visual Studio ALL CAPS menus
=====================
Use `VisualStudio_SentenceCaseMenus.reg` for VS2012.

http://stackoverflow.com/questions/10859173/how-to-disable-all-caps-menu-titles-in-visual-studio


Paint.Net
=========

[Paint.Net](http://www.getpaint.net/index.html) is a free improvement over mspaint that isn't as complex as Photoshop. Use `Windows_OpenWithPaintNet.reg` to change your "Edit" menu on images to use Paint.Net installed with scoop. It changes the application in `Computer\HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit\command` to `C:\Users\dbriscoe\scoop\apps\paint.net\current\PaintDotNet.exe` (make sure that file exists).

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


File Explorer
=============
Restore the old Context Menu in Windows 11

1. Right-click the Start button and choose Windows Terminal.
2. Copy the command from below, paste it into Windows Terminal Window, and press enter.
     reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
4. Restart File Explorer or your computer for the changes to take effect.
5. You see the Legacy Right Click Context menu by default.
https://answers.microsoft.com/en-us/windows/forum/all/restore-old-right-click-context-menu-in-windows-11/a62e797c-eaf3-411b-aeec-e460e6e5a82a

Remove VLC
https://stackoverflow.com/a/37090548/79125
Remove PlayWithVLC-dir and add string value named "Extended" to AddToPlaylistVLC-dir (so it's in Shift-Right-Click).

Remove ads:
* Replace Windows Spotlight with gallery of wallpapers I find online.
* Uninstall bloatware apps
* Hide OneDrive ads
* Settings > System > Notifications > Additional Settings. uncheck all
* Settings > Personalization > Taskbar. uncheck all
* Settings > Personalization > Start. uncheck recommendations
https://lifehacker.com/tech/how-to-block-ads-in-windows-11

Appearance:
Settings > Accessibility > Underline access keys
