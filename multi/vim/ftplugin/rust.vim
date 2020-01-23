
" rustc compiler is only good for single files, so we'll usually want cargo.
compiler cargo
DisableAutoSetCompiler


" Global entrypoint
function! s:set_entrypoint(makeprg)
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let cur_file = expand('%:p')
    " I put stuff in an src/ folder -- go up one from there.
    let parent_dir = fnamemodify(cur_file, ':h:h')

    " Use AsyncRun instead of AsyncMake so we can pass cwd and ensure
    " callstacks are loaded properly.
    " Load the cur file and close it to ensure we're building the right thing.
    " Must use :cd or closing main.rs will put us in the wrong directory and
    " our quickfix jumps to the wrong place.
    exec 'nnoremap <F6> :update<Bar>split '. cur_file .'<Bar>compiler cargo<Bar>cd '. parent_dir .'<CR>:AsyncRun -program=make -auto=make -cwd='. parent_dir .' @ build<CR>:close<CR>'
    exec 'nnoremap <Leader>ir :update<Bar>split '. cur_file .'<Bar>compiler cargo<Bar>cd '. parent_dir .'<CR>:AsyncRun -program=make -auto=make -cwd='. parent_dir .' @ run<CR>:close<CR>'
    call LocateAll()
    NotGrepUseGrepRecursiveFrom .
    " I put code in ./src/
    let g:inclement_n_dir_to_trim = 2
    let g:inclement_after_first_include = 1
endf
command! -buffer RustSetEntrypoint call s:set_entrypoint('')
