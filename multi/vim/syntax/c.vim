
" Highlight Function names
" Inspiration: http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim/773392#773392
syn match    cCustomParen    "(" contains=cParen contains=cCppParen
" cCustomFunc combines cCustomMemberFunc and cCustomStaticFunc
"syn match    cCustomFunc        "\(::\|->\|\.\)\zs\w\+\s*\ze([^)]*).*[);]" contains=cCustomParen
syn match    cCustomMemberFunc  "\(->\|\.\)\zs\w\+\ze\s*(" contains=cCustomParen
syn match    cCustomStaticFunc  "::\zs\w\+\s*\ze([^)]*).*[);]" contains=cCustomParen
hi def link cCustomMemberFunc  Function
hi def link cCustomStaticFunc  Function

" Constants are all caps with underscores. Minimum 3 characters.
" Source: http://stackoverflow.com/questions/1512602/highlighting-defined-value-in-vim/1515550#1515550
syn match cConstant "\<[A-Z][A-Z0-9_]\{3,\}\>"
hi def link cConstant Define

" Special highlight for method names
" Source: http://vim.wikia.com/wiki/Highlighting_of_method_names_in_the_definition
syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
hi def link cppFuncDef Function
