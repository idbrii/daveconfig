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
    " V: visual repo history
    nnoremap <leader>gV :Gitv --all<CR>
    " v: visual file history
    nnoremap <leader>gv :Gitv! --all<CR>
    xnoremap <leader>gv :Gitv! --all<CR>
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

    " I keep thinking this is a "Press Enter to continue" prompt.
    let g:vc_donot_confirm_cmd = 1

    " Sometimes VCDiff doesn't work. Give me a backup.
    function! s:SvnDiff(optional_revision)
        silent Scratch diff
        let revision = a:optional_revision
        if len(revision) > 0 && revision[0] != '-'
            let revision = '-r '. revision
        endif
        exec '.! svn diff # '. revision
    endf
    command! -nargs=? SvnDiff :silent call s:SvnDiff(<q-args>)

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
    nnoremap <silent> <leader>fV :exec 'VCLog! '. g:david_project_root<CR>
    nnoremap <silent> <leader>fv :VCLog! %<CR>
    " Explore
    nnoremap <silent> <leader>fe :VCBrowse<CR>
    nnoremap <silent> <leader>fEm :VCBrowse<CR>
    nnoremap <silent> <leader>fEw :VCBrowseWorkingCopy<CR>
    nnoremap <silent> <leader>fEr :VCBrowseRepo<CR>
    nnoremap <silent> <leader>fEl :VCBrowseMyList<CR>
    nnoremap <silent> <leader>fEb :VCBrowseBookMarks<CR>
    nnoremap <silent> <leader>fEf :VCBrowseBuffer<CR>
    nnoremap <silent> <leader>fq :diffoff! <CR> :q<CR>
endif


if executable('TortoiseProc')
    function! s:TortoiseCommand(command, optional_path)
        let path = a:optional_path
        if len(path) == 0
            let path = '%'
        endif
        exec 'AsyncCommand TortoiseProc /command:'. a:command .' /path:"'. path .'"'
    endf
    " A visual version of VC commands (with less capitalization please).
    " Reference: https://tortoisesvn.net/docs/release/TortoiseSVN_en/tsvn-automation.html
    command! -nargs=+ Vcv       call s:TortoiseCommand(<f-args>)
    command! -nargs=? Vcvlog    call s:TortoiseCommand('log', <q-args>)
    command! -nargs=? Vcvblame  call s:TortoiseCommand('blame', <q-args>)
    command! -nargs=? Vcvdiff   call s:TortoiseCommand('diff', <q-args>)
    command! -nargs=? Vcvswitch call s:TortoiseCommand('switch', g:david_project_root)
    command! -nargs=? Vcvrepo call s:TortoiseCommand('repobrowser', g:david_project_root)
    command! -nargs=? Vcvrepolog call s:TortoiseCommand('log', g:david_project_root)
    command! -nargs=? Vcvstatus call s:TortoiseCommand('repostatus', g:david_project_root)
endif

"}}}
" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
