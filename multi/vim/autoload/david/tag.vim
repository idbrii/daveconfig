
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
