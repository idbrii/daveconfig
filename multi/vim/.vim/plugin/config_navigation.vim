" Move within file {{{1
" work more logically with wrapped lines
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

" Jumplist - navigate previous locations
if has('jumplist')
    nnoremap <Leader>[ <C-o>
    nnoremap <Leader>] <C-i>
endif

" Between files {{{1
" Switch files
nmap ^ <C-^>
nmap <A-Left> :bp<CR>
nmap <A-Right> :bn<CR>

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

" CtrlP plugin -- fuzzy file finder {{{1
let g:ctrlp_use_caching = 1
let g:ctrlp_extensions = ['funky', 'register']
let g:ctrlp_max_depth = 32
let g:ctrlp_by_filename = 1
let g:ctrlp_dotfiles = 0
" I generate a filelist file in the root of my project that tells me where all
" the interesting files are. That's far faster than searching.
let g:ctrlp_user_command = ['filelist', 'cat %s/filelist']
let g:ctrlp_root_markers = ['filelist']

" don't store temp files or git files
if has("win32")
    let g:ctrlp_mruf_exclude = '.*\\\.git\\.*\|^c:\\temp\\.*\|\\AppData\\Local\\Temp\\'
else
    let g:ctrlp_mruf_exclude = '.*/\.git/.*\|^/tmp/.*\|^/var/tmp/.*'
endif

let g:ctrlp_map = '<A-S-o>'
nmap <C-S-o> :CtrlPBuffer<CR>
nmap <A-S-m> :CtrlPMRUFiles<CR>
nmap <A-S-l> :CtrlPLastMode<CR>

" Like gf but use filelist instead of path
nmap <Leader>gf :CtrlP <C-r>=expand('<cfile>:t')<CR><CR><CR>

" Open header/implementation -- gives list of files with the same name using
" Leader first because cpp.vim has faster <A-o> (and doesn't change last
" command)
nnoremap <Leader><A-o> :CtrlP<CR><C-r>#<Esc>F."_C.

" Netrw plugin -- Navigate filesystems {{{1
" Make \e like \be but for netrw
nnoremap <Leader>e :Explore<CR>
nnoremap <C-w><Leader>e :Vexplore<CR>
" Set browsed dir as current dir
let g:netrw_keepdir = 0

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
