" s:function copied from abolish.vim v1.1
function! s:function(name)
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '<SNR>\d\+_'),''))
endfunction

" s:snakecase copied from abolish.vim v1.1
function! s:snakecase(word)
  let word = substitute(a:word,'::','/','g')
  let word = substitute(word,'\(\u\+\)\(\u\l\)','\1_\2','g')
  let word = substitute(word,'\(\l\|\d\)\(\u\)','\1_\2','g')
  let word = substitute(word,'[.-]','_','g')
  let word = tolower(word)
  return word
endfunction

" Convert for sentences: words separated by spaces.
function! s:spacecase(word)
  return substitute(s:snakecase(a:word),'_',' ','g')
endfunction
" Convert for titles: capitalized words separated by spaces.
function! s:titlecase(word)
  let word = s:snakecase(a:word)
  " Capitalize first and after underscore
  let word = substitute(word,'\v^.|_\zs.','\u&','g')
  " Space case
  let word = substitute(word,'_',' ','g')
  return word
endfunction

call extend(Abolish, {
      \ 'spacecase':  s:function('s:spacecase'),
      \ 'titlecase':  s:function('s:titlecase'),
      \})
call extend(Abolish.Coercions, {
      \ ' ': Abolish.spacecase,
      \ 't': Abolish.titlecase,
      \})
