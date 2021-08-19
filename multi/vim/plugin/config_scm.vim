" Source Control

set diffopt+=vertical
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience,indent-heuristic
endif

" Mergetool          {{{1

" Remote vs Merged since merged contains changes on top of what's in remote.
let g:mergetool_layout = 'rm'

" I want equal sized windows.
function s:on_mergetool_set_layout(split)
    " Relayout windows too.
    wincmd =
    " Ensure filetypes are set.
    if empty(&filetype) && !empty(a:split.filetype)
        execute 'setfiletype' a:split.filetype
    endif
endfunction
let g:MergetoolSetLayoutCallback = function('s:on_mergetool_set_layout')

" Meld          {{{1
if executable('meld')
    " Invoke meld to easily diff the current directory
    " Only useful if we're in a version-controlled directory

    " :e is used to change to current file's directory. See vimrc.
    nnoremap <Leader>gD :e<CR>:!meld . &<CR>
endif

" Git          {{{1
if executable('git')

    " I almost always do verbose, so define my own Gcommit that uses full
    " vertical height. See vim-fugitive#1519.
    function! s:GitCommit(line1, line2, range, bang, mods, args) abort
        let bufnr = bufnr()
        exec fugitive#Command(a:line1, a:line2, a:range, a:bang, a:mods, a:args)
        if bufnr != bufnr()
            wincmd _
        endif
    endf

    command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#CommitComplete Gcommit call s:GitCommit(<line1>, <count>, +"<range>", <bang>0, "<mods>", "commit " .. <q-args>)

    " Fugitive
    nnoremap <Leader>gi :Git<CR>gg)
    nnoremap <Leader>gd :Gdiffsplit<CR>

    " GV
    " V: visual repo history
    nnoremap <leader>gV :GV<CR>
    " v: visual file history
    nnoremap <leader>gv :GV!<CR>
    xnoremap <leader>gv :GV!<CR>

    function! s:Gblame(range, args)
        " :Gblame scrollbinds the blame window but doesn't support time travel.
        " Instead, use :%Gblame which uses a disconnected blame window and
        " supports C-i/o to travel through time (even across reblames).
        let winview = winsaveview()
        exec a:range ..'Git blame '.. a:args
        wincmd T
        call winrestview(winview)
        " Offset to the right past the commit info column.
        normal! 64l
    endf
    command! -bar -range=% -nargs=? Gblame :silent! cd %:p:h | call <sid>Gblame('<line1>,<line2>', <q-args>)
    nnoremap <Leader>gb :Gblame<CR>

    command! -range Gpopupblame call setbufvar(winbufnr(popup_atcursor(systemlist("git -C ".. shellescape(expand('%:p:h')) .." log --no-merges -n 1 -L <line1>,<line2>:" .. shellescape(resolve(expand("%:t")))), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")
    xnoremap <Leader>gb :Gpopupblame<CR>

    command! Ghistory GV! --all

    function! s:GitRevert(commit)
        try
            exec 'Git revert --no-commit '. a:commit
            if v:shell_error <= 1
                " No problems means we can go straight to commit.
                " On Windows
                Git commit -v
                return
            endif
        catch /^fugitive:/
            " TODO: How to get fugitive hint to draw?
            " It shows in terminal, so should be okay.
            echo v:exception
        endtry
        " How to open status regardless of fugitive errors?
        Git
    endf
    command! -nargs=1 Grevert call s:GitRevert(<f-args>)

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
" Randomly maps a common key globally for grep.
let g:no_vc_maps = 1

" Currently, I only use vc for svn.
if executable('svn')
    " I like to do extra formatting.
    let g:vc_commit_allow_blank_lines = 1

    " I keep thinking this is a "Press Enter to continue" prompt.
    let g:vc_donot_confirm_cmd = 1

    " Sometimes VCDiff doesn't work. Give me a backup.
    function! s:SvnDiff(fname, optional_revision)
        silent Scratch diff
        let revision = a:optional_revision
        if len(revision) > 0 && revision[0] != '-'
            let revision = '-r '. revision
        endif
        exec '.! svn diff '. a:fname .' '. revision
        if has('mac')
            %sm/\r$//
        endif
    endf
    command! -nargs=? SvnDiff :silent call s:SvnDiff(expand("%"), <q-args>)

    function! s:SvnUser()
        let auth = systemlist("svn auth")
        for entry in auth
            if entry =~# '^Username:'
                return split(entry)[1]
            endif
        endfor
        return ''
    endf
    function! s:SvnRepoUrl()
        return split(systemlist("svn info ".. g:david_project_root)[2])[1]
    endf
    function! s:SvnRelativeDate(seconds_from_now)
        " Date relative to today
        let today = localtime()
        return strftime("{%Y-%m-%d}", today + a:seconds_from_now)
    endf

    function! s:SvnDay(days_ago)
        " Show log of changes made by local user today.
        " Should I put this into sovereign?
        let days = 24*60*60
        " Use today and tomorrow. svn will search based on start of day. See
        " https://stackoverflow.com/a/15759896/79125
        let search = ''
        let user = s:SvnUser()
        if !empty(user)
            let search = '--search '.. user
        endif
        let cmd = printf("svn log --revision %s:%s %s %s", s:SvnRelativeDate(-a:days_ago * days), s:SvnRelativeDate((1 - a:days_ago)*days), search, s:SvnRepoUrl())
        let log = systemlist(cmd)
        let log = map(log, { i, val -> trim(val) })
        silent Scratch svnlog
        call append(0,log)
        0put =cmd
        " Snap to width used
        vertical resize 81
    endf
    command! -count=0 SvnDay call s:SvnDay(<count>)

    " Easy copy message from svn when committing to git. Uses the file under
    " cursor (from a git commit message buffer).
    function! s:SvnLastMessage() abort
        let fname = expand('<cfile>')
        if !empty(fname)
            " Assuming we're in a COMMIT_EDITMSG from .git
            let fname = printf('%s/../%s', expand('%:h'), fname)
        endif
        if !filereadable(fname)
            " Wasn't on a file, try last buffer.
            let fname = expand('#')
        endif

        " incremental omits a trailing line
        let log = systemlist("svn log --limit 1 --incremental ".. fname)
        if v:shell_error
            silent 0put =v:shell_error
        endif
        
        let log = map(log, { k,v -> trim(v) })
        silent 1put =log[:2]
        silent 0put =log[3:]
        norm! gg
    endf
    command! SvnLastMessage call s:SvnLastMessage()

    " There's no VCShow like git show.
    command! -nargs=+ SvnShow :Sedit <args>

    " VCMove often fails. Requires relative or repo paths, but even then it
    " thinks I'm moving to the filesystem. This is probably not as safe, but
    " works.
    function! s:SvnMove(src, dest) abort
        let shellslash_bak = &shellslash
        let &shellslash = 0

        let src = shellescape(a:src)
        let output = system('svn mv '. src .' '. shellescape(a:dest))
        if v:shell_error
            echo output
        else
            exec 'keepalt edit '. a:dest
        endif

        let &shellslash = shellslash_bak
        return !v:shell_error
    endf
    command! -nargs=1 -complete=file MoveSvn :call s:SvnMove(expand("%:p"), <q-args>)
    function! s:SvnMoveUnity(src, dest) abort
        let success = s:SvnMove(a:src .'.meta', a:dest .'.meta')
        if success
            call s:SvnMove(a:src, a:dest)
        else
            echo 'Try MoveSvn instead.'
        endif
    endf
    command! -nargs=1 -complete=file MoveUnity :call s:SvnMoveUnity(expand("%:p"), <q-args>)

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
        if has('mac')
            %sm/\r$//
        endif
        " My hack to vim-vc calls diffusable for me.
        "call diffusable#diff_with_partner(winnr('#'))
        wincmd p
        "call diffusable#diff_with_partner(winnr('#'))
    endf

    " For some reason VCDiff takes ~5 seconds to do a diff, but !svn diff
    " and cat are instant. This one takes about 2 seconds.
    function! s:VCDiffFast(revision) abort
        let lazyredraw_bak = &lazyredraw
        set lazyredraw
        let itchy_bak = g:itchy_split_direction
        let g:itchy_split_direction = 1

        mark c

        " Ensure svn will have a path inside the repo.
        silent! cd %:p:h

        " Get a nice name for the diff file. No noticeable affect on perf.
        let shellslash_bak = &shellslash
        let &shellslash = 0
        let repo_file = shellescape(expand('%:p'))
        let &shellslash = shellslash_bak
        for line in systemlist('svn info '. repo_file)
            if line =~# 'is not a working copy'
                echohl WarningMsg
                echomsg trim(line)
                echohl None
                return

            elseif line =~# '^URL'
                let repo_file = substitute(line, '\vURL: (https?://.{-}.com/)?svn', '', '')
                let repo_file = substitute(repo_file, '%20', ' ', 'g') " url-encoded
                let repo_file = substitute(repo_file, '[%#]', '', 'g') " not allowed
                let repo_file = repo_file[:-2] " remove newline
                break
            endif
        endfor

        let base_file = system('svn cat -r'. a:revision .' '. expand('%'))
        if has('mac')
            " Line endings are messed up on mac, but I'm not sure why. Let's
            " just hide them so my diffs are useable.
            let base_file = substitute(base_file, '\r\n', '\n', 'g')
        endif
        call diffusable#diff_this_against_text(base_file)

        wincmd p
        exec 'silent file '. bufname('%') .'-'. repo_file .'\#'. a:revision
        wincmd p
        " Try to ensure cursor is at the same position. Also close up folds
        " and centre cursor.
        normal! `czMzz

        let g:itchy_split_direction = itchy_bak
        let &lazyredraw = lazyredraw_bak

        " Sometimes when cursor was on unchanged text, base window isn't on
        " the right line and you see no content. Flipping over to it fixes it,
        " but we want to end in local file. I think this must be done while
        " we're redrawing?
        " TODO: Still need to flip around? With the above wincmds?
        "wincmd p
        "wincmd p
    endf
    " We're loaded before vc, so we can't clobber VCDiff
    command! VCDiffFast call s:VCDiffFast('HEAD')

    function! s:VCUpdate(...)
        let shellslash_bak = &shellslash
        let &shellslash = 0
        
        let files = a:000[:]
        if a:0 == 0
            let files = [expand('%')]
        endif
        
        for i in range(0, len(files)-1)
            let files[i] = shellescape(fnamemodify(files[i], ':p'))
        endfor

        let result = system('svn update '. join(files))
        echo result

        let &shellslash = shellslash_bak
    endf

    command! -nargs=? VCUpdate call s:VCUpdate(<f-args>)

    " Ensure the blame window will have a path inside the repo.
    nnoremap <silent> <leader>fb :silent! cd %:p:h <Bar>silent VCBlame<CR>
    " Diff against have revision.
    nnoremap <silent> <leader>fd :Sdiff<CR>
    " Diff against head revision.
    nnoremap <silent> <leader>fD :Sdiff % HEAD<CR>
    nnoremap <silent> <leader>fi :Sstatus<CR>
    nnoremap <silent> <leader>fIu :VCStatus -u<CR>
    nnoremap <silent> <leader>fIq :VCStatus -qu<CR>
    nnoremap <silent> <leader>fIc :VCStatus .<CR>
    nnoremap <silent> <leader>fV :exec 'Sclog! '. g:david_project_root<CR>
    nnoremap <silent> <leader>fv :Sclog<CR>
    " Explore
    nnoremap <silent> <leader>fe :VCBrowse<CR>
    nnoremap <silent> <leader>fEm :VCBrowse<CR>
    nnoremap <silent> <leader>fEw :VCBrowseWorkingCopy<CR>
    nnoremap <silent> <leader>fEr :VCBrowseRepo<CR>
    nnoremap <silent> <leader>fEl :VCBrowseMyList<CR>
    nnoremap <silent> <leader>fEb :VCBrowseBookMarks<CR>
    nnoremap <silent> <leader>fEf :VCBrowseBuffer<CR>
    nnoremap <silent> <leader>fq :diffoff! <CR> :q<CR>
    nnoremap <silent> <leader>f* :<C-u>call vc#grep#do("*".fnamemodify(expand('%'), ':e'), expand("<cword>")) <CR>
    vnoremap <silent> <leader>f* :<C-u>call vc#grep#do("*".fnamemodify(expand('%'), ':e'), expand("<cword>")) <CR>
endif


if executable('TortoiseProc')
    function! s:TortoiseCommand(command, optional_path) abort
        let path = a:optional_path
        if len(path) == 0
            let path = '%'
        endif
        let path = david#path#to_unix(path)
        " Ensure svn will have a path inside the repo.
        if isdirectory(path)
            let dir = fnamemodify(path, ':p')
        else
            let dir = fnamemodify(path, ':p:h')
        endif
        exec 'cd' dir
        exec 'AsyncCommand TortoiseProc /command:'. a:command .' /path:"'. path .'"'
    endf
    function! s:TortoiseCommandOnInputPathOrRoot(command, path) abort
        let path = a:path
        if empty(path)
            let path = g:david_project_root
        endif
        return s:TortoiseCommand(a:command, path)
    endfunction
    " A visual version of VC commands (with less capitalization please).
    " Reference: https://tortoisesvn.net/docs/release/TortoiseSVN_en/tsvn-automation.html
    command! -nargs=+ Vcv       call s:TortoiseCommand(<f-args>)
    command! -nargs=? Vcvlog    call s:TortoiseCommand('log', <q-args>)
    command! -nargs=? Vcvblame  call s:TortoiseCommand('blame', <q-args>)
    command! -nargs=? Vcvdiff   call s:TortoiseCommand('diff', <q-args>)
    command! -nargs=? Vcvswitch call s:TortoiseCommandOnInputPathOrRoot('switch', <q-args>)
    command! -nargs=? Vcvrepo call s:TortoiseCommandOnInputPathOrRoot('repobrowser', <q-args>)
    command! -nargs=? Vcvrepolog call s:TortoiseCommandOnInputPathOrRoot('log', <q-args>)
    command! -nargs=? Vcvstatus call s:TortoiseCommandOnInputPathOrRoot('repostatus', <q-args>)
endif

"}}}
" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
