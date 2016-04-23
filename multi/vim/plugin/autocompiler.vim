
" Since FileType occurs after all ftplugins execute, we need to allow them to
" skip autodetection to do unobvious compiler settings.
command! DisableAutoSetCompiler let b:autocompiler_skip_detection = 1
" Force a specific buildsystem/compiler instead of autodetecting. This will
" kill all autodetection except in after/ftplugin/.
command! -nargs=1 ForceSetCompiler let g:compiler_buildsystem = <q-args>

function! s:AutoSetCompiler(ftype)
    if exists('b:autocompiler_skip_detection') && b:autocompiler_skip_detection
        return
    endif

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
