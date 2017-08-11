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
