" Use spell checking for writable files
if !&readonly
    setlocal spell
endif

" Text files probably have no useful syntax, so use manual
setlocal foldmethod=manual

" Text files might have numbered lists
setlocal formatoptions+=n

" English isn't case-sensitive. Use my original case when completing.
setlocal infercase
