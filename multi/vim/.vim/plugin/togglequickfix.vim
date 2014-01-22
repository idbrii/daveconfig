" Quickly open/close quickfix
function <SID>QuickFixToggle(prefix)
    if len(a:prefix) != 1
        echoerr 'QuickFixToggle requires the prefix of l or c'
        return
    endif

    if &buftype == 'quickfix'
        " If we're already in a quickfix window, then we should close it.
        " We use [cl]close instead of :quit to ensure that we close the
        " requested window.
        execute a:prefix . 'close'
    else
        " If we're not in a quickfix buffer, try to open a quickfix of the
        " requested type.
        execute a:prefix . 'open'
		execute "nnoremap <silent> <buffer> q :". a:prefix ."close<CR>"
    endif
endfunction

nnoremap <silent> <Plug>(togglequickfix-c) :call <SID>QuickFixToggle('c')<CR>
nnoremap <silent> <Plug>(togglequickfix-l) :call <SID>QuickFixToggle('l')<CR>

" Make it easier to turn these off in case I'm troubleshooting mappings.
if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
      \ (! exists('no_togglequickfix_maps') || ! no_togglequickfix_maps)
    nmap <unique> <Leader>wc <Plug>(togglequickfix-c)
    nmap <unique> <Leader>wl <Plug>(togglequickfix-l)
endif
