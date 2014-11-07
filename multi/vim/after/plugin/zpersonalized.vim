" My personalizations that are overwritten by plugins. Putting them here
" ensures they're mapped to my desires.

" Esc without straying too far from homerow. Otherwise just inserts ^B. (See i_CTRL-B-gone.)
" Possible alternative: C-s (used experiementally by surround).
inoremap <C-b> <Esc>

" Syntax folding is particularly slow, but if we have fastfold, then it's
" fast. We defaulted to indent before (which is okay), but syntax is better.
" See vimrc.vim.
if exists("g:loaded_fastfold") && g:loaded_fastfold
    set foldmethod=syntax		" By default, use syntax to determine folds
endif
