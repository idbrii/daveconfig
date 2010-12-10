" Using javacomplete from
" http://www.vim.org/scripts/script.php?script_id=1785
setlocal omnifunc=javacomplete#Complete
" parameter info is optional
setlocal completefunc=javacomplete#CompleteParamsInfo 
" Suggested maps:
"inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P> 
"inoremap <buffer> <C-S-Space> <C-X><C-U><C-P> 


" Abbreviations that are useful in java

" for Java: Copies type and sets up new
iabbrev jnew <ESC>BBByE$anew <ESC>pa);<ESC>hi

" for Java: makes main signature
iabbrev jmain public static void main (String[] args)

" for Java: output shortcuts
iabbrev Sout System.out.println
iabbrev Serr System.err.println

" for Java: import shortcuts
iabbrev Iawt import java.awt.*;
iabbrev Iswing import javax.swing.*;
iabbrev Ijava import java.*;<ESC>bi

