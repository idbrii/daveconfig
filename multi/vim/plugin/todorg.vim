" Use org to make todos

let s:todorg_plan_file = "~/plan.org"

exec "command! Todo split ". s:todorg_plan_file

function! s:NewTodo()
    if expand("%:p") != expand(s:todorg_plan_file)
		Todo
    endif

    " New task
	exec "normal G\<Plug>OrgNewHeadingBelowAfterChildrenNormal"

    " Boilerplate
	"call append(line('.'), "Effort: 0h")
	"call append(line('.'), "Estimate: 4h")
	normal =G
endf
command! TodoNew call s:NewTodo()
