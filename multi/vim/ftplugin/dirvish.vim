" Some fancy mappings to work on paths.
" Stolen from tpope/vim-vinegar@ac893960c324d879b6923a4c1abaea352d8caeb5

function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

function! s:escaped(first, last) abort
  let files = getline(a:first, a:last)
  return join(map(files, '<SID>fnameescape(v:val)'), ' ')
endfunction

nnoremap <buffer> ~ :edit ~/<CR>
nnoremap <buffer> . :<C-U> <C-R>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
xnoremap <buffer> . <Esc>: <C-R>=<SID>escaped(line("'<"), line("'>"))<CR><Home>
nmap <buffer> ! .!
xmap <buffer> ! .!
