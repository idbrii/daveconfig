
" For plugin ZFDirDiff
function! s:ZF_GetPaths(path)
    let absolute = ZF_DirDiffPathFormat(a:path, ':p')
    let home_relative = ZF_DirDiffPathFormat(a:path, ':~')
    let cwd_relative = ZF_DirDiffPathFormat(a:path, ':.')
    let is_under_cwd = absolute != cwd_relative
    return [is_under_cwd, cwd_relative, home_relative]
endf
function! david#diff#DirDiff_headerText()
    let left_paths = s:ZF_GetPaths(t:ZFDirDiff_fileLeft)
    let right_paths = s:ZF_GetPaths(t:ZFDirDiff_fileRight)
    let index = 2
    if left_paths[0] && right_paths[0]
        " Both are relative to cwd, so use cwd instead.
        let index = 1
    endif
    
    if b:ZFDirDiff_isLeft
        let path = left_paths[index]
        let side = 'LEFT'
    else
        let path = right_paths[index]
        let side = 'RIGHT'
    endif
    let text = []
    call add(text, '['.. side ..']: ' .. path .. '/')
    call add(text, '------------------------------------------------------------')
    return text
endf

function! david#diff#DirDiff_DirDiffEnter()
    setlocal cursorline
    " zfdirdiff has no help map, so improvise. @ means buffer-local.
    nnoremap <buffer> g? :<C-u>Unite mapping -input=@\  -start-insert<CR>
endf
