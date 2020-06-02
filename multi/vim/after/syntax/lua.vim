" TODO: Can I figure out how to replace ~= with ≠ ?
if !has('conceal')
    finish
endif
    finish

let g:lua_syntax_nosymboloperator = 1
unlet g:lua_syntax_nosymboloperator

syntax clear luaSymbolOperator

syntax match luaNiceNotEqOperator "\V~=" conceal cchar=≠
"~ syntax match luaSymbolOperator "[#<>^&|*/%+-]\|\.\.\|==\|[^~]="
syntax match luaSymbolOperator "[#<>=~^&|*/%+-]\|\.\." contains=luaNiceNotEqOperator

hi def link luaSymbolOperator    luaOperator
hi def link luaNiceNotEqOperator luaOperator
hi! link Conceal luaOperator

set conceallevel=2

finish

"~ syntax clear

"~ " remove the keywords. we'll re-add them below
"~ syntax clear pythonOperator

"~ syntax keyword pythonOperator is

"~ syntax match pyNiceOperator "\<in\>" conceal cchar=∈
"~ syntax match pyNiceOperator "\<or\>" conceal cchar=∨
"~ syntax match pyNiceOperator "\<and\>" conceal cchar=∧
"~ syntax match pyNiceOperator "\<not " conceal cchar=¬
"~ syntax match pyNiceOperator "<=" conceal cchar=≤
"~ syntax match pyNiceOperator ">=" conceal cchar=≥
"~ syntax match pyNiceOperator "==" conceal cchar=≡
"~ syntax match pyNiceOperator "!=" conceal cchar=≠
"~ syntax match pyNiceOperator "\<not in\>" conceal cchar=∉
"~ syntax match pyNiceOperator "\V~=" conceal cchar=≠

"~ syntax keyword pyNiceStatement lambda conceal cchar=λ
"~ syntax keyword pyNiceStatement int conceal cchar=ℤ
"~ syntax keyword pyNiceStatement float conceal cchar=ℝ
"~ syntax keyword pyNiceStatement complex conceal cchar=ℂ

"~ hi link pyNiceOperator Operator
"~ hi link pyNiceStatement Statement
"~ hi! link Conceal Operator

"~ set conceallevel=2
