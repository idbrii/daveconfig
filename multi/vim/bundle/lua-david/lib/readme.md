Download:

* Windows x64 Executables (lua-5.3.4_Win64_bin.zip)
    * http://luabinaries.sourceforge.net/download.html
* Static Libraries (lua-5.3.4_Win64_vc10_lib.zip)
    * https://sourceforge.net/projects/luabinaries/files/5.3.4/Windows%20Libraries/Static/

and put them here:

    ~/.vim/bundle/lua-david$ tree lib
        lib
        ├── lua-5.3
        │   ├── include
        │   │   ├── lauxlib.h
        │   │   ├── luaconf.h
        │   │   ├── lua.h
        │   │   ├── lua.hpp
        │   │   └── lualib.h
        │   ├── lua53.dll
        │   ├── lua53.exe
        │   ├── lua53.lib
        │   ├── luac53.exe
        │   └── wlua53.exe
        └── readme.md


Includes are for luarocks.

You can install luarocks like so:

    .\install.bat   /P C:\david\apps\lua\luarocks-5.3 /selfcontained /noadmin /LUA %USERPROFILE%\.vim\bundle\lua-david\lib\lua-5.3

However, that didn't actually work. luarocks doesn't understand this lib file
and barfs [1]. Maybe because I'm using VS2008 and luabinaries only offers
VS2010 and newer.

Instead, I installed luaforwindows and followed the instructions on this
comment [2] to get luarocks to have a more recent version of luafilesystem
(followed verbatim because using a more recent luarocks 2.4.2 failed). I still
couldn't get luacheck to install, so I used `luarocks install luacheck
--deps-mode=none` which didn't work on other environments. Now I finally have
luacheck working.

[1]: https://github.com/keplerproject/luafilesystem/issues/82
[2]: https://github.com/rjpcomputing/luaforwindows/issues/80#issuecomment-193851597
