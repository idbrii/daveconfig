if expand('%:t') != 'makelove.toml'
    finish
endif

runtime ftplugin/lua_makelove.vim
