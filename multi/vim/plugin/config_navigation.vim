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

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-left>   Bh

" Shift + Arrows - Visually Select text
"nnoremap  <s-up>     Vk
"nnoremap  <s-down>   Vj
"nnoremap  <s-right>  vl
"nnoremap  <s-left>   vh

" Quick toggle cursor at centre of screen.
nnoremap <Leader>vc :let &scrolloff=999-&scrolloff<CR>
" Quick wrap toggle
nnoremap <Leader>vw :setlocal invwrap<CR>

" Jumplist - navigate previous locations
if has('jumplist')
    nnoremap <Leader>[ <C-o>
    nnoremap <Leader>] <C-i>
endif

" Between files {{{1
" Switch files
nnoremap ^ <C-^>
nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>

" Ctrl+Shift+PgUp/Dn - Move between files
nnoremap <C-S-PageDown> :next<CR>
nnoremap <C-S-PageUp> :prev<CR>
" \+PgUp/Dn - Move between tabs
nnoremap <Leader><PageDown> :tabnext<CR>
nnoremap <Leader><PageUp> :tabprev<CR>
" \Bksp - Advance tabs
nnoremap <Leader><Backspace> :tabnext<CR>
" Ctrl+PgUp/Dn - Move between quickfix marks
nnoremap <C-PageDown> :cnext<CR>
nnoremap <C-PageUp> :cprev<CR>
" Alt+PgUp/Dn - Move between location window marks
nnoremap <A-PageDown> :lnext<CR>
nnoremap <A-PageUp> :lprev<CR>

" Quickly launch input data
if has("win32")
    if &shellslash
        " Forwardslashes are great, but cmd.exe won't handle them. Convert to 
        " backslash.
        function s:Gogo(filename)
            let fname = substitute(fnamemodify(a:filename, ':p'), '/', '\\', 'g')
            exec '! start '. fname
        endfunction
        command! -nargs=1 -complete=file Gogo call s:Gogo("<args>")
    else
        command! -nargs=1 -complete=file Gogo ! start <args>
    endif
elseif has("macunix")
    " TODO: Does this work as expected? Does it need q-quoting?
    command! -nargs=1 -complete=file Gogo ! open <args>
elseif has("unix")
    " TODO: Does this work as expected? Does it need q-quoting?
    command! -nargs=1 -complete=file Gogo ! xdg-open <args>
endif

" CtrlP plugin -- fuzzy file finder {{{1
let g:ctrlp_use_caching = 1
let g:ctrlp_max_depth = 32
let g:ctrlp_by_filename = 1
let g:ctrlp_dotfiles = 0
let g:ctrlp_max_height = &lines / 2

let g:ctrlp_regexp = 1
let g:ctrlp_prompt_mappings = { 'PrtAdd(".*")': ['<space>'] }
let g:ctrlp_lazy_update = 100

" I don't keep persistent file explorers, so allow them to be re-used (likely
" I opened them and then decided to use ctrlp instead).
let g:ctrlp_reuse_window = 'netrw\|bufexplorer'

" I generate a filelist file in the root of my project that tells me where all
" the interesting files are. That's far faster than searching.
if has("win32")
    " cygwin cat suddenly stopped working.
    let g:ctrlp_user_command = ['filelist', 'type %s\\filelist']
else
    let g:ctrlp_user_command = ['filelist', 'cat %s/filelist']
endif
let g:ctrlp_root_markers = ['filelist']

" don't store temp files or git files
if has("win32")
    let g:ctrlp_mruf_exclude = '.*\\\.git\\.*\|^c:\\temp\\.*\|\\AppData\\Local\\Temp\\'
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
" Don't ever do C-o so nothing happens if I take too long.
nnoremap <unique> <C-o> <nop>

let g:airline#extensions#ctrlp#show_adjacent_modes = 0

" Like gf but use filelist instead of path
" You still need to type <C-\>s to populate the name.
"nnoremap <Leader>gf :let @/ = '\<'. expand('<cfile>:t') .'\>'<Bar> CtrlP<CR>

" Open header/implementation -- gives list of files with the same name using
" Leader first because cpp.vim has faster <A-o> (and doesn't change last
" command)
" You still need to type <C-\>s to populate the name.
nnoremap <Leader><A-o> :let @/ = '\<'. expand('%:t:r') .'\>'<Bar> CtrlP<CR>

" Code Search version of find symbol (finds text, not symbol).
" Faster than cscope.
nnoremap <unique> <Leader><A-S-g> :NotGrep <C-r>=expand('<cword>')<CR><CR>

" Netrw plugin -- Navigate filesystems {{{1
" Make \e like \be but for netrw
nnoremap <Leader>e :Explore<CR>
nnoremap <C-w><Leader>e :Vexplore<CR>
" Set browsed dir as current dir
let g:netrw_keepdir = 0

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
