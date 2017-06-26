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
    " v: visual repo history
    nnoremap <leader>gv :Gitv --all<CR>
    " V: visual file history
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
    " I like to do extra formatting.
    let g:vc_commit_allow_blank_lines = 1

    " Sometimes VCDiff doesn't work. Give me a backup.
    function! s:SvnDiff()
        silent Scratch diff
        .! svn diff #
    endf
    command! SvnDiff :silent call s:SvnDiff()

    " There's no VCShow like git show.
    function! s:SvnShow(revision)
        silent Scratch diff
        " This is a re-implementation of
        " ~/data/settings/daveconfig/multi/svn/bin/svn-show because the Bash
        " on Windows win32-unix interface is flaky.
        "exec '.! bash.exe -c '. expand('~/data/settings/daveconfig/multi/svn/bin/svn-show') .' '. a:revision

        exec '.!svn log --verbose   --change '. a:revision .' .'
        normal! Go
        exec '.!svn diff            --change '. a:revision .' .'
        %s/\r//e
        normal! gg
    endf
    command! -nargs=+ SvnShow :silent call s:SvnShow(<args>)

    function! s:VCDiffWithDiffusable(diff_latest)
        "" Make VCDiff auto-disable diff mode when one window is closed.

        " Ensure the diff window will have a path inside the repo.
        silent! cd %:p:h
        if a:diff_latest
            " 'Forces diff to start with the revision from the trunk/branch for subversion.'
            " Seems to mean diff latest instead of diff have revision.
            silent VCDiff!
        else
            " Seems to diff against have revision.
            silent VCDiff
        endif
        " My hack to vim-vc calls diffusable for me.
        "call diffusable#diff_with_partner(winnr('#'))
        wincmd p
        "call diffusable#diff_with_partner(winnr('#'))
    endf

    " Ensure the blame window will have a path inside the repo.
    nnoremap <silent> <leader>fb :silent! cd %:p:h <Bar>VCBlame<CR>
    " Diff against have revision.
    nnoremap <silent> <leader>fd :call <SID>VCDiffWithDiffusable(0)<CR>
    " Diff against head revision.
    nnoremap <silent> <leader>fD :call <SID>VCDiffWithDiffusable(1)<CR>
    nnoremap <silent> <leader>fi :VCStatus<CR>
    nnoremap <silent> <leader>fIu :VCStatus -u<CR>
    nnoremap <silent> <leader>fIq :VCStatus -qu<CR>
    nnoremap <silent> <leader>fIc :VCStatus .<CR>
    nnoremap <silent> <leader>fv :VCLog! .<CR>
    nnoremap <silent> <leader>fV :VCLog!<CR>
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
