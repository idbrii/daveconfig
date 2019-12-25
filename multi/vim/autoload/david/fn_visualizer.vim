function! s:switch_to_win_with_buf(bufnr) abort
    let matching_windows = filter(range(1, winnr('$')), 'winbufnr(v:val) == a:bufnr')
    if len(matching_windows) > 0
        execute matching_windows[0] 'wincmd w'
        return 1
    else
        return 0
    endif
endfunction

function! s:open_scratch() abort
    if exists(':Scratch')
        vertical split
        ScratchNoSplit
    else
        vertical split new
    endif
endf

""
" Create a buffer with output of function fn for each line of input in current
" buffer. Useful for indentexpr, foldexpr, or loops processing buffer
" contents.
"
" visualize_every_line({line, lnum -> out})
"
function! david#fn_visualizer#visualize_every_line(fn) abort
    let lazyredraw_bak = &lazyredraw
    let &lazyredraw = 1
    let winview = winsaveview()

    let search_bak = @/

    let text = ''
    " Pass lnum so you can call indent().
    g/^/let text .= a:fn(getline('.'), line('.')) . "\n"

    let @/ = search_bak

    " Jump to top to ensure bind lines up properly.
    keepjumps normal! gg
    setlocal scrollbind cursorbind
    let orig_buffer = bufnr('%')

    if exists('b:fn_visualizer_partner') && s:switch_to_win_with_buf(b:fn_visualizer_partner)
        " Clear contents.
        keepjumps normal! gg"_dG
    else
        " Create and setup scratch buffer.
        call s:open_scratch()

        " Put pointers to other buffer.
        let new_buffer = bufnr('%')
        let b:fn_visualizer_partner = orig_buffer
        execute orig_buffer .'buffer'

        augroup fn_visualizer
            au! * <buffer>
            " Autoclose the fn_visualizer when parent is closed.
            au BufWinLeave <buffer> call david#fn_visualizer#on_closed_parent(expand('<afile>'))
        augroup END

        let b:fn_visualizer_partner = new_buffer
        execute new_buffer .'buffer'

        augroup fn_visualizer
            au! * <buffer>
            " turn off options when child is closed
            au BufWinLeave <buffer> call david#fn_visualizer#on_closed_child(expand('<afile>'))
        augroup END
        setlocal scrollbind cursorbind
        setlocal buftype=nofile nowrap
    endif

    vertical resize 7
    silent 0put =text

    wincmd p

    " Ensure scrollbind is aligned properly
    norm! Ggg

    call winrestview(winview)
    let &lazyredraw = lazyredraw_bak
endf

function! david#fn_visualizer#partner_from_bufname(name) abort
    return getbufvar(a:name, 'fn_visualizer_partner')
endf

" Visualized window closed.
function! david#fn_visualizer#on_closed_parent(parent_bufname) abort
    let child_bufnr = getbufvar(a:parent_bufname, 'fn_visualizer_partner')
    if len(child_bufnr) == 0
        return
    endif
    " Visualizer window now has no use. Close it.
    exec "bdelete ". child_bufnr
endf

" Visualizer (scratch) window closed.
function! david#fn_visualizer#on_closed_child(child_bufname) abort
    let parent_bufnr = getbufvar(a:child_bufname, 'fn_visualizer_partner')
    if len(parent_bufnr) == 0
        return
    endif

    let current = bufnr('%')
    " Clean up window settings we modified in visualized window.
    keepalt keepjumps call s:switch_to_win_with_buf(parent_bufnr)
    setlocal noscrollbind nocursorbind
    unlet b:fn_visualizer_partner
    keepalt keepjumps call s:switch_to_win_with_buf(current)
endf

