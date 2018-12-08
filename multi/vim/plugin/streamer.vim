function! s:OpenWindow()
    if !exists('g:streamer_bufnr')
        Scratch markdown
        let g:streamer_bufnr = bufnr('%')
        let g:streamer_visible = 1
        augroup Streamer
            au!
            autocmd BufHidden <buffer> let g:streamer_visible = 0
        augroup END
        " We built our scratch window. Now hide it so opening it is always the
        " same code path.
        close
    endif
    if bufnr('%') == g:streamer_bufnr
        return
    endif
    if g:streamer_visible
        let winnr = bufwinnr(g:streamer_bufnr)
        exec winnr .'wincmd w'
    else
        topleft split
    endif
    exec 'buffer '. g:streamer_bufnr
    resize 2
    let g:streamer_visible = 1
endf

function! s:StartStream()
    if !exists('g:streamer_original_font')
        let g:streamer_original_font = &guifont
    endif
    set guifont=Menlo-Regular:h14
    nnoremap \ :<C-u>StreamerWindow<CR>
    StreamerWindow
endf

function! s:EndStream()
    let &guifont = g:streamer_original_font
    unlet g:streamer_original_font
    unlet g:streamer_bufnr
    unlet g:streamer_visible
endf


" TODO:
" * only define window and map during stream
" * autoload
" * / in window resizes and switches back to other window (minimize)
command! StreamerWindow call s:OpenWindow()
command! StreamerStart call s:StartStream()
command! StreamerEnd call s:EndStream()
