
" Force a specific buildsystem/compiler instead of autodetecting. This will
" kill all autodetection except in after/ftplugin/.
command! -nargs=1 ForceSetCompiler let g:compiler_buildsystem = <q-args>

function! s:AutoSetCompiler(ftype)
    let c = a:ftype
    " If I'm using a buildsystem, then use it instead.
    if exists('g:compiler_buildsystem')
        let c = g:compiler_buildsystem
    endif
    exe 'silent! compiler '. c
endf
augroup AutoCompiler
    au!
    " If it exists, load the appropriate compiler.
    autocmd FileType * call s:AutoSetCompiler(expand('<amatch>'))
augroup END
