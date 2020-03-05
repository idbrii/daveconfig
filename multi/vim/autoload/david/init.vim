" Code used in vimrc and other sourced-on-startup
" (No lazy loading here!)

function! david#init#find_ft_match(ft_list)
    return index(a:ft_list, &ft)
endf


" Only show abnormal status.
function! david#init#asyncrun_status()
    if len(g:asyncrun_status) == 0 || g:asyncrun_status == 'success'
        return ''
    elseif g:asyncrun_status == 'running'
        return 'async '
    elseif g:asyncrun_status == 'failed'
        return 'fail '
    endif
    return ''
endf
