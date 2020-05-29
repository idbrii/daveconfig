" A shim around netrw for any plugins that expect netrw to exist (like
" vim-markdown).

function! netrw#BrowseX(url, ignored) abort
    call OpenBrowser(a:url)
endf
