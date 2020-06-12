" Move within file {{{1
" work more logically with wrapped lines.
" Also changes the behavior of dj since I'm remapping operator-pending mode.
" But it makes dj behave like j which probably makes sense.
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" don't interfere with selection mode
sunmap j
sunmap k

" Quick toggle cursor at centre of screen.
nnoremap <Leader>vc :<C-u>let &scrolloff=999-&scrolloff <Bar> set scrolloff?<CR>
" Quick wrap toggle
nnoremap <Leader>vw :<C-u>setlocal invwrap <Bar> set wrap?<CR>
" Quick spelling toggle
nnoremap <Leader>vs :<C-u>setlocal invspell <Bar> set spell?<CR>
" Show cursor (crosshairs like a t)
nnoremap <Leader>vt :<C-u>set invcursorline invcursorcolumn<CR>

" Jumplist - navigate previous locations
if has('jumplist')
    nnoremap <Leader>[ <C-o>
    nnoremap <Leader>] <C-i>
    " Use arrows to move in jump list. :jumps shows newest at the bottom so
    " down moves you towards newest.
    nnoremap <A-Up> <C-o>
    nnoremap <A-Down> <C-i>
endif

" Use same mnemonic as motions: b for (block) and B for {BLOCK}.
nnoremap [b [(
nnoremap ]b ])
nnoremap [B [{
nnoremap ]B ]}

" Between files {{{1
" Switch files
nnoremap ^ <C-^>
nnoremap <BS> <C-^>
nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>

" Ctrl+Shift+PgUp/Dn - Move between files
nnoremap <C-S-PageDown> :next<CR>
nnoremap <C-S-PageUp> :prev<CR>
" Ctrl+PgUp/Dn - Move between quickfix marks. Jump to current first to ensure
" we always jump to something.
nnoremap <C-PageDown> :cc<Bar>cnext<CR>
nnoremap <C-PageUp> :cc<Bar>:cprev<CR>
" Alt+PgUp/Dn - Move between quickfix files
nnoremap <A-PageDown> :cnfile<CR>
nnoremap <A-PageUp> :cpfile<CR>
" Ctrl+Alt+PgUp/Dn - Move between location window marks
nnoremap <C-A-PageDown> :lnext<CR>
nnoremap <C-A-PageUp> :lprev<CR>

" Use <Leader>w for window management.
" togglequickfix enhances some of these window management maps.
nnoremap <Leader>w <C-w>
" Don't close vim with this map. Behave like :close instead of :quit. This is
" inconsistent, but I got used to wq for quickfix and need to break that
" habit.
nnoremap <Leader>wq <C-w>c
" Close (delete) the buffer, but keep its space.
nnoremap <Leader>wQ :Bdelete<CR>

nnoremap <Leader>wN :tabedit<CR>
" Make it easy to open in a tab. I often prefer this over wT (move to tab).
nnoremap <Leader>w<Space> :<C-u>split <Bar> wincmd T<CR>



" Code Search analog to find symbol (finds text, not symbol). Generally faster
" than cscope. New mnemonic: Jump to word.
nnoremap <unique> <A-g> :<C-u>NotGrep \b<cword>\b<CR>
nnoremap <unique> <Leader>jw :<C-u>NotGrep \b<cword>\b<CR>
nnoremap <unique> <Leader>jW :<C-u>NotGrep \b<cWORD>\b<CR>
xnoremap <unique> <Leader>jw "cy:<C-u>call notgrep#search#NotGrep('grep', '\b'. @c .'\b')<CR>
" Less precise version (\b is word boundary). Map is similar to `*` vs `g*`.
nnoremap <unique> g<A-g> :<C-u>NotGrep <cword><CR>
nnoremap <unique> <Leader>jgw :<C-u>NotGrep <cword><CR>
nnoremap <unique> <Leader>jgW :<C-u>NotGrep <cWORD><CR>
xnoremap <unique> <Leader>jgw "cy:<C-u>call notgrep#search#NotGrep('grep', @c)<CR>
nnoremap <unique> <Leader>jq :<C-u>NotGrepFromSearch<CR>

" Jump to tag
nnoremap <unique> <Leader>jt <C-]>
nmap     <unique> <Leader>jT <Plug>(lsp-definition)
" Preview window for tags
nnoremap <unique> <Leader>jp :<C-u>ptag <C-r><C-w><CR>
nmap     <unique> <Leader>jP :<C-u>call david#tag#preview_jump({ -> execute('LspDefinition')})<CR>
" Show info (hover for lsp)
nnoremap <unique> <Leader>ji :<C-u>HoverUnderCursor<CR>
" Jump to symbol
nnoremap <unique> <Leader>js :<C-u>AsyncCscopeFindSymbol <cword><CR>

if exists("##BufWinEnter") && exists("##BufEnter")
    " Show cursorline in preview window to make symbol we jumped to stand out.
    " Hide cursorline when we enter that window to avoid annoyance.
    function! s:ClearCursorLineIfAutoSet()
        if exists('w:david_cursorline')
            unlet w:david_cursorline
            setlocal nocursorline
            exec 'augroup David_PreviewWindow_'. winnr()
                au!
            augroup end
        endif
    endf
    function! s:ShowCursorLineUntilEnter()
        setlocal cursorline
        let w:david_cursorline = 1
        exec 'augroup David_PreviewWindow_'. winnr()
            au!
            autocmd BufEnter <buffer> call s:ClearCursorLineIfAutoSet()
        augroup end
    endf
    augroup David_PreviewWindow
        au!
        autocmd BufWinEnter * if &previewwindow | call s:ShowCursorLineUntilEnter() | endif
    augroup end
endif

" dirvish plugin -- Navigate filesystems {{{1

" dirvish and open-browser replace netrw.
" My only use for Netrw is browsing remote
" filesystems, but I can turn it back on when necessary.
let g:loaded_netrw       = 0
let g:loaded_netrwPlugin = 0
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" netrw support for fugitive's Browse
command! -nargs=1 Browse Gogo <args>

" Set browsed dir as current dir.
let g:netrw_keepdir = 0

" Mark {{{1
let g:mw_no_mappings = 1
nmap <unique> <silent> <Leader>m <Plug>MarkSet
vmap <unique> <silent> <Leader>m <Plug>MarkSet
nmap <unique> <silent> <Leader>M <Plug>MarkAllClear


" Nrrwrgn {{{1

" Default is full screen narrow. I usually narrow to limit the application of
" substitutions without worrying about setting the range. Also, use n as the
" narrow prefix.
xmap <unique> <Leader>nr <Plug>NrrwrgnBangDo
nmap <unique> <Leader>nr :<C-u>WidenRegion!<CR>
xmap <unique> <Leader>nR <Plug>NrrwrgnDo

" Narrow multiple regions
xmap <unique> <Leader>nm :NRPrepare<CR>
nmap <unique> <Leader>nm :<C-u>NRMulti<CR>


" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
