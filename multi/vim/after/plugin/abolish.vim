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

" Easily convert into sentences: words separated by sentences.
function! s:spacecase(word)
  return substitute(s:snakecase(a:word),'_',' ','g')
endfunction

call extend(Abolish, {
      \ 'spacecase':  s:function('s:spacecase')
      \})

call extend(Abolish.Coercions, {
      \ ' ': Abolish.spacecase
      \})
