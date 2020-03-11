" Source Control
finish

" Trying to automatically switch between source control with the same
" mappings.

let s:scm = {}

" Git          {{{1
if executable('git')

    let s:scm.git = { 'nno': {}, 'xno': {} }
    " Fugitive
    let s:scm.git.nno.i = ":Gstatus .<CR>gg<C-n>"
    let s:scm.git.nno.d = ":Gdiff<CR>"

    " Gitv
    " V: visual repo history
    let s:scm.git.nno.V = ":Gitv --all<CR>"
    " v: visual file history
    let s:scm.git.nno.v = ":Gitv! --all<CR>"
    let s:scm.git.nno.v = ":Gitv! --all<CR>"
    let s:scm.git.nno.b = ":silent! cd %:p:h<CR>:Gblame<CR>"

    let s:scm.git.xno.v = ":Gitv! --all<CR>"
    let g:Gitv_DoNotMapCtrlKey = 1

endif

" Currently, I only use vc for svn.
if executable('svn')

    " Ensure the blame window will have a path inside the repo.
    "nnoremap <silent> <leader>fb :silent! cd %:p:h <Bar>VCBlame<CR>
    " Diff against have revision.
    "nnoremap <silent> <leader>fd :call <SID>VCDiffWithDiffusable(0)<CR>
    " Diff against head revision.
    "nnoremap <silent> <leader>fD :call <SID>VCDiffWithDiffusable(1)<CR>
    "nnoremap <silent> <leader>fi :VCStatus<CR>
    "nnoremap <silent> <leader>fIu :VCStatus -u<CR>
    "nnoremap <silent> <leader>fIq :VCStatus -qu<CR>
    "nnoremap <silent> <leader>fIc :VCStatus .<CR>
    "nnoremap <silent> <leader>fV :exec 'VCLog! '. g:david_project_root<CR>
    "nnoremap <silent> <leader>fv :VCLog! %<CR>
    " Explore
    "nnoremap <silent> <leader>fe :VCBrowse<CR>
    "nnoremap <silent> <leader>fEm :VCBrowse<CR>
    "nnoremap <silent> <leader>fEw :VCBrowseWorkingCopy<CR>
    "nnoremap <silent> <leader>fEr :VCBrowseRepo<CR>
    "nnoremap <silent> <leader>fEl :VCBrowseMyList<CR>
    "nnoremap <silent> <leader>fEb :VCBrowseBookMarks<CR>
    "nnoremap <silent> <leader>fEf :VCBrowseBuffer<CR>
    "nnoremap <silent> <leader>fq :diffoff! <CR> :q<CR>


    let s:scm.svn = { 'nno': {} }

    let s:scm.svn.nno.b = ":silent! cd %:p:h <Bar>VCBlame<CR>"
    let s:scm.svn.nno.d = ":call <SID>VCDiffWithDiffusable(0)<CR>"
    let s:scm.svn.nno.D = ":call <SID>VCDiffWithDiffusable(1)<CR>"
    let s:scm.svn.nno.i = ":VCStatus<CR>"
    let s:scm.svn.nno.Iu = ":VCStatus -u<CR>"
    let s:scm.svn.nno.Iq = ":VCStatus -qu<CR>"
    let s:scm.svn.nno.Ic = ":VCStatus .<CR>"
    let s:scm.svn.nno.V = ":exec 'VCLog! '. g:david_project_root<CR>"
    let s:scm.svn.nno.v = ":VCLog! %<CR>"
    let s:scm.svn.nno.e = ":VCBrowse<CR>"
    let s:scm.svn.nno.Em = ":VCBrowse<CR>"
    let s:scm.svn.nno.Ew = ":VCBrowseWorkingCopy<CR>"
    let s:scm.svn.nno.Er = ":VCBrowseRepo<CR>"
    let s:scm.svn.nno.El = ":VCBrowseMyList<CR>"
    let s:scm.svn.nno.Eb = ":VCBrowseBookMarks<CR>"
    let s:scm.svn.nno.Ef = ":VCBrowseBuffer<CR>"
    let s:scm.svn.nno.q = ":diffoff! <CR> :q<CR>"

endif

function! Gget_scm_dict()
    " fugitive commands only exist if current buffer is in git repo.
    if exists(":Gwrite")
        return s:scm.git
    else
        return s:scm.svn
    endif
endf

let all_keys = []
for system_key in keys(s:scm)
    call extend(all_keys, keys(s:scm[system_key]))
endfor
for key in keys(s:scm.svn)
    "<unique> 
    "~ exec '"nnoremap <silent> <Leader>g'. key .' :<C-u>exec <SID>get_scm_dict()["'. key .'"]<CR>'
    "~ ec '"nnoremap <expr> <silent> <Leader>g'. key .' <SID>get_scm_dict().'. key
endfor

" TODO: Maybe instead of this, I'll have to map a specific scm-agnostic
" command and switch to the scm-specific command?
function! s:Execute(mode)
    let key = nr2char(getchar())
    if exists(":Gwrite")
        return s:scm.git[a:mode][key]
    else
        return s:scm.svn[a:mode][key]
    endif
endf

nnoremap <expr> <silent> <Plug>(david-scm-normal) <SID>Execute('nno')
xnoremap <expr> <silent> <Plug>(david-scm-xvisual) <SID>Execute('xno')
nmap <Leader>y <Plug>(david-scm-normal)
xmap <Leader>y <Plug>(david-scm-xvisual)

"}}}
" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
