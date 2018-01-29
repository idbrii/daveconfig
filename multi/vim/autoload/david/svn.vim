function! david#svn#create_resolve_file()
    " Get the merge details
    exec "normal! gg0I:: \<Esc>j."
    0,2delete c

    " Only care about conflict files
    %v/\v^(tree )?conflict/d
    %sm/^Tree conflict: /@call :resolvetree /e
    %sm/^Conflicted: /@call :resolvefile /e
    %sort
    0put c
    normal! Go
    let subroutines = [''
                \ , '@goto:eof'
                \ , ''
                \ , ':resolvefile'
                \ , 'svn resolve --accept theirs-full %*'
                \ , '@goto:eof'
                \ , ''
                \ , ':resolvetree'
                \ , 'svn resolve --accept theirs-full %*'
                \ , '@REM svn wants to do this but that loses incoming data:'
                \ , '@REM svn resolve --accept working %*'
                \ , '@REM This answer says something crazy:'
                \ , '@REM https://stackoverflow.com/a/11016568/79125'
                \ , '@REM Ugh.'
                \ , '@goto:eof'
                \ ]
    call append('$', subroutines)
    update
    " highlight binary files
    let @/ = '\vzip|fla|png|exe'
    silent normal! n
endf


" Confirm revert before proceeding.
function! david#svn#ConfirmRevert(...)
    let files = join(a:000, ' ')
    if len(files) == 0
        let files = expand('%')
    endif
    if confirm("Revert?\n". files, "&Yes\n&No") == 1
        call call('vc#Revert', a:000)
    endif
endf

function! david#svn#get_branch()
    if !exists("*systemlist")
        " Could implement it ourself...
        return ""
    endif

    if exists("b:svndavid_branch")
        return b:svndavid_branch
    endif

    " airline needs us to track our svn directory for some reason.
    let b:svn_dir = finddir(".svn", '.;/') " somewhere above us

    " Always define it so we don't keep retrying. Clear it when we leave the
    " buffer so it's somewhat up to date.
    let b:svndavid_branch = ""
    " Use a buffer-unique group name to prevent clearing autocmds for other
    " buffers.
    exec 'augroup svndavid-'. bufnr("%")
        au!
        autocmd BufWinLeave <buffer> unlet! b:svndavid_branch
    augroup END

    let shellslash_bak = &shellslash
    let &shellslash = 0
    " Based on: https://stackoverflow.com/a/39516489/79125
    let svninfo = systemlist("svn info ". shellescape(expand("%:p:h")))
    let &shellslash = shellslash_bak

    for line in svninfo
        let branch = matchstr(line, '\v^URL:.*\zs((tags|branches)/[^/]+|trunk)', 0, 1)
        let branch = substitute(branch, '\v^[^/]+/', '', '')
        if len(branch) > 0
            let b:svndavid_branch = branch
            return branch
        endif
    endfor
    return ""
endf

