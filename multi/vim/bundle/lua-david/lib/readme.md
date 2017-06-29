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


Includes are needed for luarocks.

You can install luarocks like so:

    .\install.bat   /P C:\david\apps\lua\luarocks-5.3 /selfcontained /noadmin /LUA %USERPROFILE%\.vim\bundle\lua-david\lib\lua-5.3
