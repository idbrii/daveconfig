""" Settings
set ignorecase					" search is case insensitive
set smartcase					" search case sensitive if caps on
set hlsearch					" Highlight matches to the search
set incsearch					" Find as you type

" Allow commands like :find to search recursively from the current file's
" directory. Ideally, I should set path to some useful directories, but I
" don't have a good working set right now.
set path+=./**


" Magic global search (see smagic)
nmap gs :%sm/
xmap gs :sm/

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" * and # search for next/previous of selected text when used in visual mode
xnoremap g* y/<C-R>"<CR>
xnoremap g# y?<C-R>"<CR>


" Quick fix slashes
"	win -> unix
xnoremap <A-/> :s/\\/\//g<CR>:nohl<CR>
"	unix -> win
xnoremap <A-?> :s/\//\\/g<CR>:nohl<CR>

" Quickly find todo items
nmap <Leader>t :vimgrep "\CTODO" %<CR>
nmap <Leader>T :grep TODO -R .

" Redo search with whole word toggled
function! <SID>ToggleWholeWord()
    " Adds or removes the \<\> word boundary markers on the current search
    " Note: Only applies to search query as a whole

    " remove whole word boundaries if they exists
    let search = substitute(@/, '\\<\(.*\)\\>', '\1', '')
    if search == @/
        " there were no whole word flags, so add them
        let search = '\<' . search . '\>'
    endif
    let @/ = search
endfunction
nmap <Leader>/ :call <SID>ToggleWholeWord()<CR>n

" Easy grep for current query
nmap <Leader>* :grep -e "<C-r>/" *

" Easy cmdline run (normal, visual)
map <Leader>\ :!<up><CR>
ounmap <Leader>\

"""""""""""
" Functions {{{1

" Remove all text except what matches the current search result
" The opposite of :%s///g (which clears all instances of the current search.
" Note: Clobbers the c register
function! ClearAllButMatches()
    let @c=""
    %s//\=setreg('C', submatch(0), 'l')/g
    %d _
    put c
    0d _
endfunction

"}}}

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
