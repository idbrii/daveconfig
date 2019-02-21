" Catch errors
" Highlight missing :
syn match pythonBadStyle "^\s*def\s\+\w\+(.*)\s*(#.*)$" display
syn match pythonBadStyle "^\s*class\s\+\w\+(.*)\s*(#.*)$" display
syn match pythonBadStyle "^\s*for\s.*[^:](#.*)$" display
syn match pythonBadStyle "^\s*except\s*(#.*)$" display
syn match pythonBadStyle "^\s*finally\s*(#.*)$" display
syn match pythonBadStyle "^\s*try\s*(#.*)$" display
syn match pythonBadStyle "^\s*else\s*(#.*)$" display
syn match pythonBadStyle "^\s*else\s*[^:].*" display
syn match pythonBadStyle "^\s*if\s[^#]*[^\:](#.*)$" display
syn match pythonBadStyle "^\s*except\s.*[^\:](#.*)$" display

" For Style
" ; is valid but ugly python, and I use it by accident.
syn match pythonBadStyle "[;]$" display
" Don't even think about using nonexistent do keyword.
syn keyword pythonBadStyle         do

" TODO: Consider an autocmd that switches to Include/NONE for readonly files
" and Error otherwise. It's not quite an error, but it looks bad.
hi def link pythonBadStyle         Error

" Fix some ugliness from gh:hdima/python-syntax
" Magic header comment doesn't need to stick out as something special.
hi def link pythonCoding           Comment
hi def link pythonRun              Comment
" Imports should look like includes.
hi def link pythonPreCondit        Include

