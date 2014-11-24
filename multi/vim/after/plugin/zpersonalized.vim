" My personalizations that are overwritten by plugins. Putting them here
" ensures they're mapped to my desires.

" Esc without straying too far from homerow. Otherwise just inserts ^B. (See i_CTRL-B-gone.)
" Possible alternative: C-s (used experiementally by surround).
inoremap <C-b> <Esc>
" Esc without leaving homerow. Also, you can hammer C-l and eventually it
" redraws the screen. Also used to complete more characters in popupmenu. See
" popupmenu-keys.
inoremap <expr> <C-l> pumvisible() ? '<C-l>' : '<Esc>'

" Syntax folding is particularly slow, but if we have fastfold, then it's
" fast. We defaulted to indent before (which is okay), but syntax is better.
" See vimrc.vim.
if exists("g:loaded_fastfold") && g:loaded_fastfold
    set foldmethod=syntax		" By default, use syntax to determine folds
endif
