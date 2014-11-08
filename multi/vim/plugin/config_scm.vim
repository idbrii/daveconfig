" Source Control

set diffopt+=vertical

" Meld          {{{1
if executable('meld')
    " Invoke meld to easily diff the current directory
    " Only useful if we're in a version-controlled directory

    " :e is used to change to current file's directory. See vimrc.
    nnoremap <Leader>gD :e<CR>:!meld . &<CR>
endif

" Git          {{{1
if executable('git')
    
    " Fugitive
    nnoremap <Leader>gi :Gstatus<CR>gg<C-n>
    nnoremap <Leader>gd :Gdiff<CR>

    " Gitv
    nnoremap <leader>gv :Gitv --all<CR>
    nnoremap <leader>gV :Gitv! --all<CR>
    xnoremap <leader>gV :Gitv! --all<CR>
    nnoremap <Leader>gb :silent! cd %:p:h<CR>:Gblame<CR>
    let g:Gitv_DoNotMapCtrlKey = 1
    
    command! Ghistory Gitv! --all

    " Delete Fugitive buffers when I leave them so they don't pollute BufExplorer
    augroup FugitiveCustom
        autocmd BufReadPost fugitive://* set bufhidden=delete
    augroup END
endif

" Perforce          {{{1
let no_perforce_maps = 1
let g:p4CheckOutDefault = 1		" Yes as default
let g:p4MaxLinesInDialog = 0	" 0 = Don't show the dialog, but do I want that?

"}}}
" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
