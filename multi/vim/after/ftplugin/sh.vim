" Include hyphens in shell keywords to make completing options easier.
setlocal iskeyword+=-
let &l:makeprg = shellescape(expand("%:p"))

setlocal keywordprg=:Man
