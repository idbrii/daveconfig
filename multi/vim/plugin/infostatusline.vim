" InfoStatusLine
" Author: pydave
" Toggles an informative statusbar

if exists('loaded_infostatusline ')
  finish
endif
let loaded_infostatusline = 1


set laststatus=2				" Always show statusline, even if only 1 window
if !exists('g:alt_statusline')
    let g:alt_statusline = 'ascii:%-3b hex:%2B  %= %l,%c%V %P '
endif

function <SID>UseInfoStatusLine()
    let l:swap_statusline = &statusline
    let &statusline = g:alt_statusline
    let g:alt_statusline = l:swap_statusline
endfunction

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    map <Leader>s :call <SID>UseInfoStatusLine()<CR>
endif
