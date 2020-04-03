" Invoke with:
" vim -Nu ~/.vim/reprovimrc.vim -U NONE

" all plugins should work with sensible as a baseline.
let s:plugins = ['sensible']

" Vimscript debugging tools.
let s:plugins += ['lookup']
let s:plugins += ['scriptease']
let s:plugins += ['vader']

" Plugins to test here ------------------------------------------
let s:plugins += ['matchup']
" /end ----------------------------------------------------------

set runtimepath-=~/.vim
set runtimepath-=~/.vim/after
set runtimepath-=~/vimfiles
set runtimepath-=~/vimfiles/after
for plugin in s:plugins
    exec "set runtimepath^=~/.vim/bundle/". plugin
    exec "set runtimepath+=~/.vim/bundle/". plugin ."/after"
endfor
set viminfofile=NONE

set hlsearch
colorscheme desert

let mapleader=' '
inoremap <C-l> <Esc>
nnoremap <Leader>w <C-w>
nnoremap <Leader>fs :update<CR>
set ignorecase smartcase

source ~/.vim/plugin/config_display.vim
FontDefault
