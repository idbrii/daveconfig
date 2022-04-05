" These are the parts of vim-cpp-modern that aren't STL and aren't covered by
" the built-in syntax.


" Highlight additional keywords in the comments
syn keyword cTodo contained BUG NOTE


" Highlight function names
if get(g:, 'cpp_function_highlight', 1)
    syn match cUserFunction "\<\h\w*\>\(\s\|\n\)*("me=e-1 contains=cParen,cCppParen
    hi def link cUserFunction Function
endif


" Highlight struct/class member variables
if get(g:, 'cpp_member_highlight', 0)
    syn match cMemberAccess "\.\|->" nextgroup=cStructMember,cppTemplateKeyword
    syn match cStructMember "\<\h\w*\>\%((\|<\)\@!" contained
    syn cluster cParenGroup add=cStructMember
    syn cluster cPreProcGroup add=cStructMember
    syn cluster cMultiGroup add=cStructMember
    hi def link cStructMember Identifier

    if &filetype ==# 'cpp'
        syn keyword cppTemplateKeyword template
        hi def link cppTemplateKeyword cppStructure
    endif
endif


" Highlight all standard C keywords as Statement
" This is very similar to what other IDEs and editors do
if get(g:, 'cpp_simple_highlight', 0)
    hi! def link cStorageClass Statement
    hi! def link cStructure    Statement
    hi! def link cTypedef      Statement
    hi! def link cLabel        Statement
endif
