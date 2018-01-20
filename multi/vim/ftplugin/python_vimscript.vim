" For making vim plugins in python.

" Reload the current python module in vim.
" Source: https://stackoverflow.com/a/23865944/79125
command! -nargs=0 -bar -buffer PythonReloadInVim exec 'python print(reload(__import__("'. expand("%:t:r") .'")))'
" Python 3:
"~ command! -buffer PythonReloadInVim exec 'python import imp; print(imp.reload(__import__('. expand("%:t:r") .')))'.
nnoremap <buffer> <Leader>vso :<C-u>update<Bar> PythonReloadInVim<CR>
