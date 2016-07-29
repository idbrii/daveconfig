" A do-what-I-mean command for exchange. Automatically selects WORDs on either
" side of the cursor to exchange. Preserves common end statement characters.

" vim-exchange doesn't define a load guard, so use a command instead. (Better
" would be a Plug, but I don't know how.)
"if !exists('loaded_exchange')
if exists(':XchangeClear') != 2
    " Requires vim-exchange
    finish
endif


function! s:back_off_from_separator()
    call search('.\%#[;,]', 'b', line("."))
endf

function! s:char_under_cursor()
    " http://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endf

function! s:is_in_matched_parens()
    normal! mcvib
    exec "normal! \<Esc>`c"
    return getpos("'<") != getpos("'>") 
endf

function! s:invoke_exchange()
    exec "norm \<Plug>(Exchange)"
endf

function! s:try_invoke_sideways()
    if exists("g:loaded_sideways") && g:loaded_sideways > 0
        exec "norm \<Plug>SidewaysRight"
        return 1
    endif
    return 0
endf

function! s:exchange_dwim()
    " For commas in matched braces, use a smarter algorithm: Sideways!
    if s:char_under_cursor() == ',' && s:is_in_matched_parens()
        if s:try_invoke_sideways()
            return
        endif
    endif

    let lazyredraw_bak = &lazyredraw

    let win_save = winsaveview()

    " Find first word at or after cursor
    call search('\w', 'c', line("."))
    " Select it
    normal! viW
    " Ensure we didn't select a semicolon or comma
    call s:back_off_from_separator()
    " Mark for exchange.
    call s:invoke_exchange()
    " Go back to start point.
    call winrestview(win_save)
    " Select previous word
    normal! BviW
    call s:back_off_from_separator()
    " Exchange it.
    call s:invoke_exchange()

    " Restore original cursor position.
    call winrestview(win_save)

    let &lazyredraw = lazyredraw_bak

    " Uses tpope's repeat.vim for dot repeating
    silent! call repeat#set("\<Plug>(exchange-dwim)")
endf

command! XchangeDwim keepjumps keepmarks call s:exchange_dwim()
nnoremap <Plug>(exchange-dwim) :<C-u>XchangeDwim<CR>

