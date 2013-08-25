" Catch errors
" Highlight missing :
syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*for\s.*[^:]$" display
syn match pythonError "^\s*except\s*$" display
syn match pythonError "^\s*finally\s*$" display
syn match pythonError "^\s*try\s*$" display
syn match pythonError "^\s*else\s*$" display
syn match pythonError "^\s*else\s*[^:].*" display
syn match pythonError "^\s*if\s[^#]*[^\:]$" display
syn match pythonError "^\s*except\s.*[^\:]$" display

" For Style
" ; is valid but ugly python, and I use it by accident.
syn match pythonError "[;]$" display
" Don't even think about using nonexistent do keyword.
syn keyword pythonError         do 

" Fix some ugliness from gh:hdima/python-syntax
" Magic header comment doesn't need to stick out as something special.
hi def link pythonCoding           Comment
hi def link pythonRun              Comment
" Imports should look like includes.
hi def link pythonPreCondit        Include
