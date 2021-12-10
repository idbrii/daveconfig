" Window layout and management functions

" Automatic layout restoration {{{1
" Source: http://vim.1045645.n5.nabble.com/Initial-Window-Position-tp1165538p1165539.html
"
" Restore screen size and position
" Courtesy of Steve Hall.
" Modified by David Fishburn to base it on gvim servername.

function! david#window#layout_restore()
    " - Remembers and restores winposition, columns and lines stored in
    "   global variables written to viminfo
    " - Must follow font settings so that columns and lines are accurate
    "   based on font size.

    call david#must(has('gui_running'), 'layout management requires gui')

    " initialize
    if !exists("g:COLS_".v:servername)
        let g:COLS_{v:servername} = &columns
    endif
    if !exists("g:LINES_".v:servername)
        let g:LINES_{v:servername} = &lines
    endif
    if !exists("g:WINPOSX_".v:servername)
        " don't set to 0, let window manager decide
        let g:WINPOSX_{v:servername} = ""
    endif
    if !exists("g:WINPOSY_".v:servername)
        " don't set to 0, let window manager decide
        let g:WINPOSY_{v:servername} = ""
    endif

    " set
    execute "set columns=".g:COLS_{v:servername}
    execute "set lines=".g:LINES_{v:servername}
    execute "winpos ".g:WINPOSX_{v:servername}." ".g:WINPOSY_{v:servername}

endfunction

function! david#window#layout_save()
    " used on exit to retain window position and size

    call david#must(has('gui_running'), 'layout management requires gui')

    let g:COLS_{v:servername} = &columns
    let g:LINES_{v:servername} = &lines

    let g:WINPOSX_{v:servername} = getwinposx()
    " filter negative error condition
    if g:WINPOSX_{v:servername} < 0
        let g:WINPOSX_{v:servername} = 0
    endif

    let g:WINPOSY_{v:servername} = getwinposy()
    " filter negative error condition
    if g:WINPOSY_{v:servername} < 0
        let g:WINPOSY_{v:servername} = 0
    endif

endfunction

function! david#window#layout_save_on_exit()
    call david#must(has('gui_running'), 'layout management requires gui')

    augroup david_window
        au!
        autocmd VimLeavePre * call david#window#layout_save()
    augroup end
endfunction


" Quickfix convenience {{{1

function! david#window#copen_without_moving_cursor()
    let must_go_back = &buftype != 'quickfix'
    copen
    if must_go_back
        wincmd p
    endif
endf

