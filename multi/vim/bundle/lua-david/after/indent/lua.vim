" Intended to run on top of vim-lua's indent.
" Adds chained function calls:
"    local data = self.kitchen
"        :getContents()
"        :getCheese()
"        :enjoyCheese(self
"            :mouth()
"            :open()
"            :extendTongue())
"        :eatCheese()
"        :digestCheese()
" https://github.com/tbastos/vim-lua

setlocal indentexpr=DavidGetLuaIndent(v:lnum)

function! s:IsBlankLine(lnum)
    return getline(a:lnum) =~# '^\s*$'
endfunction

function! s:IsChainedLine(lnum)
    return getline(a:lnum) =~# '^\s*:\w'
endfunction

function! DavidGetLuaIndent(lnum)
    let indent = GetLuaIndent()
    let prev_line = prevnonblank(a:lnum - 1)
    let was_chained = s:IsChainedLine(a:lnum - 1)
    let is_chained = s:IsChainedLine(a:lnum)
    if    !was_chained && is_chained
        " start function chain
        let indent += shiftwidth()
    elseif was_chained && (is_chained || s:IsBlankLine(a:lnum))
        " keep chaining -- keep current
    elseif was_chained && !is_chained
        " end chained functions
        let indent -= shiftwidth()
    endif
    return indent
endf

