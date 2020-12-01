" For making vim plugins in python.

function! s:GetQualifiedModuleName()
    let pyx_dir = finddir("pythonx", ".;")
    let mod = ''
    if !empty(pyx_dir)
        let pyx_dir = resolve(pyx_dir)
        let fname = resolve(expand("%:p:r"))
        if fname[:len(pyx_dir)-1] == pyx_dir
            let mod = fname[len(pyx_dir)+1:]
            let mod = substitute(mod, '\\', '/', 'g')
            let mod = substitute(mod, '/', '.', 'g')
        endif
    endif
    if empty(mod)
        let mod = expand("%:t:r")
    endif
    return mod
endf

" Reload the current python module in vim.
" Source: https://stackoverflow.com/a/23865944/79125
if &pyxversion < 3
    command! -bar -buffer PythonReloadInVim exec 'python print(reload(__import__("'. s:GetQualifiedModuleName() .'")))'
else
    " vimtools is mine
    command! -bar -buffer PythonReloadInVim exec printf('pyx import vimtools; vimtools.reload_module("%s", "%s")', s:GetQualifiedModuleName(), expand("%:p"))
endif

nnoremap <buffer> <Leader>vso :<C-u>update<Bar> PythonReloadInVim<CR>
