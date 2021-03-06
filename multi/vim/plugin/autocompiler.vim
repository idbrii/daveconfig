
" Since FileType occurs after all ftplugins execute, we need to allow them to
" skip autodetection to do unobvious compiler settings.
command! DisableAutoSetCompiler let b:autocompiler_skip_detection = 1
" Force a specific buildsystem/compiler instead of autodetecting. This will
" kill all autodetection except in after/ftplugin/.
command! -nargs=1 ForceSetCompiler let g:compiler_buildsystem = <q-args>

" By default, exclude some built-in filetypes.
let g:autocompiler_blacklist = get(g:, 'autocompiler_blacklist', ['vim', 'help', 'qf'])

function! s:AutoSetCompiler(ftype)
    if index(g:autocompiler_blacklist, &filetype) >= 0
        return
    endif

    if get(b:, 'autocompiler_skip_detection')
        return
    endif

    " If I'm using a buildsystem, then use it instead.
    let c = get(g:, 'compiler_buildsystem', a:ftype)
    exe 'silent! compiler '. c
endf
augroup AutoCompiler
    au!
    " If it exists, load the appropriate compiler.
    autocmd FileType * call s:AutoSetCompiler(expand('<amatch>'))
augroup END
