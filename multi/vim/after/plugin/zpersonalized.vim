" My personalizations that are overwritten by plugins. Putting them here
" ensures they're mapped to my desires.

" Esc without straying too far from homerow. Otherwise just inserts ^B. (See i_CTRL-B-gone.)
" Possible alternative: C-s (used experiementally by surround).
inoremap <C-b> <Esc>
" Esc without leaving homerow. Also, you can hammer C-l and eventually it
" redraws the screen. Exits popupmenu when applicable.
inoremap <expr> <C-l> pumvisible() ? '<C-y>' : '<Esc>'
" Use C-y as replacement for C-l to complete more characters in popupmenu.
" it behaves similarly to its normal insert mode behavior (inserting from
" above line). See popupmenu-keys.
inoremap <expr> <C-y> pumvisible() ? '<C-l>' : '<C-y>'
" Also Esc from visual and select mode. Makes sense for snippets (my only use
" of select).
vnoremap <C-l> <Esc>

" Syntax folding is particularly slow, but fastfold reduces the cost (manually
" recomputed). vimrc.vim defines indent as default foldmethod, but since we
" have fastfold, we can use syntax for filetypes that support it.
if exists("g:loaded_fastfold") && g:loaded_fastfold
    augroup david_fdm
        au!
        autocmd BufNewFile,BufRead * call david#folding#try_use_syntax_folds()
    augroup end
endif

" DetectIndent should now be loaded.
AutoDetectIndent
