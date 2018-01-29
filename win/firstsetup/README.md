Windows
=======

## Differentiate active window
Personalization (Themes) > Colors > Title bars


vim
===

Copy vim-cache, vim-aside, and todo.org to new machine.


unix
====

Setup Bash on Windows: https://msdn.microsoft.com/en-us/commandline/wsl/install_guide

Pin the terminal to start bar.
Open %AppData%\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
Edit the shortcut and change the second blue to 77,77,255 to make it legible. Be sure to click black again before OK!


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
https://justgetflux.com/
Make sure to disable hotkeys.

www.proggyfonts.net/download/
