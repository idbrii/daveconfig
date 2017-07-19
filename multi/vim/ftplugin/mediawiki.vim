" Use spell checking for writable files
if !&readonly
    set spell
endif

if &foldmethod != 'diff'
    set foldmethod=marker
endif

iabbrev CODE <code></code>
