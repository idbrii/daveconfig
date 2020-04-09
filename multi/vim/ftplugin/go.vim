" setting undo_ftplugin like this doesn't work because this ftplugin is the
" first one read so the value is clobbered by the built-in go.vim. Not sure
" how to circumvent that without using did_ftplugin to block the built-in from
" loading.
if !exists('b:ale_fix_on_save')
    let b:undo_ftplugin = 'unlet b:ale_fix_on_save | delcommand GolangSetEntrypoint'
endif

let b:ale_fix_on_save = 1

function! s:go_run(run_args)
    let makeprg_bak = &makeprg
    let &makeprg = 'go run '. a:run_args
    AsyncMake
    let &makeprg = makeprg_bak
endf
function! s:set_entrypoint(run_args)
    " Go automatically finds the project entrypoint.

    let b:david_go_run_args = a:run_args
    command! ProjectMake AsyncMake
    command! ProjectRun  call s:go_run(b:david_go_run_args)
endf
command! -nargs=* -bang -buffer GolangSetEntrypoint call s:set_entrypoint(<q-args>)
