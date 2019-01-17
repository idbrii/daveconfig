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

" TODO: I used to remap this since I go to the previous more than next. Now
" that I'm chaining (instead of chording), is that still useful?
"nnoremap <Leader>ww :wincmd p<CR>


" CtrlP plugin -- fuzzy file finder {{{1
let g:ctrlp_use_caching = 1
let g:ctrlp_max_depth = 32
let g:ctrlp_by_filename = 1
let g:ctrlp_dotfiles = 0
let g:ctrlp_max_height = &lines / 2

let g:ctrlp_regexp = 1
let g:ctrlp_prompt_mappings = { 'PrtAdd(".*")': ['<space>'] }

" Bug: Turning on ctrlp_lazy_update allows mappings to expand. Occurs in
" kien's latest and 5f17a51a16ee9bd63ec1523d08e7c6d6a5ed6016 of ctrlpvim's
" fork. Are other plugins conflicting?
" I tried out  out adding `mapclear <buffer` to ctrlp's s:MapNorms() to see if
" that clears out my leader mappings for the ctrlp buffer. It does not (and
" it's not just leader mappings. I see it with du too.) I think I'm stuck with
" the bug or using ctrlp_lazy_update=0.
"let g:ctrlp_lazy_update = 100
let g:ctrlp_lazy_update = 0

" I don't keep persistent file explorers, so allow them to be re-used (likely
" I opened them and then decided to use ctrlp instead).
let g:ctrlp_reuse_window = 'netrw\|bufexplorer\|Scratch'

" I usually generate a filelist file in the root of my project that tells me
" where all the interesting files are. That's far faster than searching. For
" small projects, I don't bother and fallback to .git.
if has("win32")
    " cygwin cat suddenly stopped working.
    let filelist_cmd = 'type %s\\filelist'
else
    let filelist_cmd = 'cat %s/filelist'
endif
let g:ctrlp_user_command = {
            \   'types': {
            \       1: ['filelist', filelist_cmd],
            \       2: ['.git', 'cd %s && git ls-files'],
            \   }
            \}
unlet filelist_cmd
let g:ctrlp_root_markers = ['filelist', '.git']

" don't store temp files or git files
if has("win32")
    let g:ctrlp_mruf_exclude = '.*\\\.git\\.*\|^\a:\\temp\\.*\|\\AppData\\Local\\Temp\\'
else
    let g:ctrlp_mruf_exclude = '.*/\.git/.*\|^/tmp/.*\|^/var/tmp/.*'
endif

let g:ctrlp_map = '<A-S-o>'
nnoremap <A-S-m> :CtrlPMRUFiles<CR>

let g:ctrlp_extensions = ['funky', 'register']
nnoremap <unique> <C-o>l :CtrlPLastMode<CR>
nnoremap <unique> <C-o>b :CtrlPBuffer<CR>
nnoremap <unique> <C-o>f :call ctrlp#init(ctrlp#funky#id())<CR>
nnoremap <unique> <C-o>r :CtrlPRegister<CR>
nnoremap <unique> <C-o>h :CtrlPCmdHistory<CR>
nnoremap <unique> <C-o>s :CtrlPSearchHistory<CR>
nnoremap <unique> <C-o>n :call CtrlPSameName(0)<CR>
nnoremap <unique> <C-o>N :call CtrlPSameName(1)<CR>
" Don't ever do C-o so nothing happens if I take too long.
nnoremap <unique> <C-o> <nop>

let g:airline#extensions#ctrlp#show_adjacent_modes = 0

" Better solution using a ctrlp option that prevents errors due to input
" interpretation from bohrshaw.
" Source: http://www.reddit.com/r/vim/comments/27epkg/switching_between_likenamed_files_with_ctrlp_no/ci5cqig
function! CtrlPInvokeWithPrefilledQuery(prefill_query)
    let g:ctrlp_default_input = a:prefill_query
    call ctrlp#init(0)
    unlet g:ctrlp_default_input
endf
function! CtrlPSameName(require_whole_word)
    let query = expand('%:t:r')
    if a:require_whole_word
        let query = '\<'. query .'\>'
    endif
    call CtrlPInvokeWithPrefilledQuery(query)
endf
nnoremap <unique> <A-o> :call CtrlPSameName(1)<CR>

" Like gf but use ctrlp instead of path
command! CtrlPGotoFile :call CtrlPInvokeWithPrefilledQuery(expand('<cfile>:t'))
" I use unite for this instead.
"nnoremap <Leader>gf :<C-u>CtrlPGotoFile<CR>

" Code Search analog to find symbol (finds text, not symbol). Generally faster
" than cscope. New mnemonic: Jump to word.
nnoremap <unique> <A-g> :<C-u>NotGrep \b<cword>\b<CR>
nnoremap <unique> <Leader>jw :<C-u>NotGrep \b<cword>\b<CR>
nnoremap <unique> <Leader>jW :<C-u>NotGrep \b<cWORD>\b<CR>
xnoremap <unique> <Leader>jw "cy:<C-u>NotGrep "\b<C-r>c\b"<CR>
" Less precise version (\b is word boundary). Map is similar to `*` vs `g*`.
nnoremap <unique> g<A-g> :<C-u>NotGrep <cword><CR>
nnoremap <unique> <Leader>jgw :<C-u>NotGrep <cword><CR>
xnoremap <unique> <Leader>jgw "cy:<C-u>NotGrep "<C-r>c"<CR>
nnoremap <unique> <Leader>jq :<C-u>NotGrepFromSearch<CR>

" Jump to tag
nnoremap <unique> <Leader>jt <C-]>
" Preview window for tags
nnoremap <unique> <Leader>jp :<C-u>ptag <C-r><C-w><CR>
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

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
