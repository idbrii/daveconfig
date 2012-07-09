" Diff arbitrary text
" 
" See autoload for implementation

if !has("diff")
    echoerr 'DiffBuff requires diff support'
    finish
endif
if exists('g:loaded_diffbuff')
    finish
endif
let g:loaded_diffbuff = 1

" DiffDeletes {{{1
" Diffs the last two deleted ranges
command -nargs=0 DiffDeletes call DiffText(@1, @2)

" Diff two strings. Use @r to pass in register r.
function DiffText(left, right)
    call diffbuff#diff_text(a:left, a:right)
endfunction


" Diff Launchers {{{1
function <SID>DiffBoth() "{{{2
    diffthis
    wincmd w
    diffthis
endfunction
command! DiffBoth call <SID>DiffBoth()
command! -nargs=1 -complete=file VDiffSp vert diffsplit <q-args>

" Diff against the file on disk. Useful for recovery. See also :help DiffOrig
function <SID>DiffSaved() "{{{2
    vert split original.vimscratch
    silent %d
    silent r #
    silent 0d_
    diffthis
    wincmd p
    diffthis
endfunction
command! DiffSaved call <SID>DiffSaved()

" Helpers {{{1
" Instead of calling diffoff -- which resets some variables, everything should
" call DiffOff() which will do diff off and then apply the user's settings.
function! MyDiffOff()
    diffoff

    " Now we want to undo changes from diffoff

    " I always use syntax unless modelines say otherwise. Unfortunately,
    " modelines won't be reapplied.
    setlocal foldmethod=syntax
    " Since the fold level changes from the diff, reset it to the start value
    exec "setlocal foldlevel=" . &foldlevelstart

    " While reloading the filetype is a good idea, it's pretty slow, so let's
    " not do that until we get bothered by it.
    " Then try to reload filetype, which might change the fold settings
    "unlet! b:did_ftplugin
    "let &filetype = &filetype
endfunction
let g:DiffOff = function("MyDiffOff")

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
