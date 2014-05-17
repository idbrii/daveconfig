
function! s:start_autosource()
    augroup autosource
        au BufWritePost <buffer> source <afile>
    augroup END
endf

function! s:stop_autosource()
    augroup autosource
        au! BufWritePost <buffer>
    augroup END
endf

command! AutosourceStart call s:start_autosource()
command! AutosourceStop call s:stop_autosource()

function! s:autosource(fname)
    exec 'source '. a:fname
endf
