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

" VC          {{{1
" The defaults are random and disorganized. Instead, let's put them all under
" one initial leader - f. (The same that perforce uses, but I don't use vc
" with perforce.)
let g:vc_allow_leader_mappings = 0

" Currently, I only use vc for svn.
if executable('svn')
    nnoremap <silent> <leader>fb :VCBlame<CR>
    nnoremap <silent> <leader>fd :VCDiff<CR>
    nnoremap <silent> <leader>fD :VCDiff!<CR>
    nnoremap <silent> <leader>fi :VCStatus<CR>
    nnoremap <silent> <leader>fIu :VCStatus -u<CR>
    nnoremap <silent> <leader>fIq :VCStatus -qu<CR>
    nnoremap <silent> <leader>fIc :VCStatus .<CR>
    nnoremap <silent> <leader>fl :VCLog!<CR>
    nnoremap <silent> <leader>fh :VCBrowse<CR>
    nnoremap <silent> <leader>fHm :VCBrowse<CR>
    nnoremap <silent> <leader>fHw :VCBrowseWorkingCopy<CR>
    nnoremap <silent> <leader>fHr :VCBrowseRepo<CR>
    nnoremap <silent> <leader>fHl :VCBrowseMyList<CR>
    nnoremap <silent> <leader>fHb :VCBrowseBookMarks<CR>
    nnoremap <silent> <leader>fHf :VCBrowseBuffer<CR>
    nnoremap <silent> <leader>fq :diffoff! <CR> :q<CR>
endif

"}}}
" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
