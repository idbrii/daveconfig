
function! david#tag#preview_jump(jump_fn)
  let lazyredraw_bak = &lazyredraw
  let &lazyredraw = 1

  " Due to cursor jumping bug, opening preview at current file is not as
  " simple as `pedit %`:
  " http://vim.1045645.n5.nabble.com/BUG-BufReadPre-autocmd-changes-cursor-position-on-pedit-td1206965.html
  let winview = winsaveview()
  let filepath = expand('%')
  silent pedit blank-file
  wincmd P
  exec 'silent edit '. filepath
  " Jump cursor back to symbol.
  call winrestview(winview)

  call a:jump_fn()
  wincmd p

  let &lazyredraw = lazyredraw_bak
endfunction


function! david#tag#pushtagstack(tagname) abort
  if !exists('*gettagstack') || !exists('*settagstack') || !has('patch-8.2.0077') " patch that adds 't' argument
    " do nothing
    return
  endif
  let curpos = s:getcurpos()
  let item = {'bufnr': curpos[0], 'from': curpos, 'tagname': a:tagname}
  let winid = win_getid()
  let stack = gettagstack(winid)
  let stack['items'] = [item]
  call settagstack(winid, stack, 't')
endf

function! s:getcurpos() abort
  let pos = getcurpos()
  " getcurpos always returns bufnr 0.
  let pos[0] = bufnr('%')
  return pos
endfunction
