" Before Vimrc
"
" This file is sourced at the beginning of the vimrc. Put anything here that
" many other things depend on and must be done first.


" Pathogen
" Load immediately -- it loads other plugins, so do it first.
runtime bundle/pathogen/autoload/pathogen.vim
" infect() is the intended entry point for pathogen. I have avoided it before
" because it cycles filetypes (when applicable). I think cycling has broken
" something for me in the past (autodetection for git commits from terminal?)
" Cycling is necessary on the default install of Ubuntu 14.04 LTS, because
" /etc/vim/vimrc sets `syntax on`. I can comment out that line and cycling is
" not necessary (g:did_load_filetypes is not true before infect is called).
if exists('g:did_load_filetypes')
    echoerr "Doing unnecessary work: g:did_load_filetypes = " . g:did_load_filetypes
endif
call pathogen#infect()


" Setup filetype and syntax. Doing these right after pathogen because
" somethings depend on them (colorschemes) and pathogen must come first.
filetype plugin indent on   " Enable+detect filetype plugins and use to indent
syntax on                   " Turn on syntax highlighting
"syntax enable				" Enable, but keep current highlighting scheme
if has("spell")
    "set spell   "check spelling (z= suggestions, zg add good word, zb bad)
    syntax spell notoplevel
endif

" Try out space as my leader
let mapleader = ' '
" TODO: Consider let maplocalleader = '\'
let maplocalleader = mapleader
noremap <Space> <Nop>
sunmap <Space>

" : is often used so this seems obvious. Super power it too.
nnoremap <Leader><Leader> q:a

" Quick show leader mappings (can't type Space since it's a separator).
cnoremap <C-Space> map <lt>Leader>

" Until I get used to Space.
noremap \ :<C-u>echoerr "\\ is not your leader"<CR>

" Unite offers similar functionality to Yankstack, but instead of stepping
" through yanks, you can incremental search them. I added
" unite-history_yank-cycle to completely replace yankstack. It's not as
" smooth, but now I don't have yank keys mapped, so those macro bugs should be
" fixed.
let g:unite_source_history_yank_enable = 1
