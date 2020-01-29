
" rustc compiler is only good for single files, so we'll usually want cargo.
compiler cargo
DisableAutoSetCompiler

" rustfmt on save. I don't like the way it formats, but if everyone is doing
" it then I'll get fewer merge conflicts.
let b:ale_fix_on_save = 1


" Global entrypoint
function! s:set_entrypoint(makeprg)
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let s:main_file = expand('%:p')
    " I put stuff in an src/ folder -- go up one from there.
    let s:parent_dir = fnamemodify(s:main_file, ':h:h')

    function! DavidProjectBuild(target)
        let lazyredraw_bak = &lazyredraw
        let &lazyredraw = 1

        " Use AsyncRun instead of AsyncMake so we can pass cwd and ensure
        " callstacks are loaded properly.
        " Load the current file (should be main.rs) and close it to ensure
        " we're building the right thing.
        " Must use :cd/chdir or closing main.rs will put us in the wrong
        " directory and our quickfix jumps to the wrong place.
        update
        exec '5split '. s:main_file
        compiler cargo
        if exists('*chdir')
            call chdir(s:parent_dir)
        else
            exec 'cd '. s:parent_dir
        endif
        exec 'AsyncRun -program=make -auto=make -cwd='. s:parent_dir .' @ '. a:target
        close

        let &lazyredraw = lazyredraw_bak
    endf
    command! ProjectMake call DavidProjectBuild("build --release")
    command! ProjectRun  call DavidProjectBuild("run --release")
    call LocateAll()
    NotGrepUseGrepRecursiveFrom .
    " I put code in ./src/
    let g:inclement_n_dir_to_trim = 2
    let g:inclement_after_first_include = 1
endf
command! -buffer RustSetEntrypoint call s:set_entrypoint('')
