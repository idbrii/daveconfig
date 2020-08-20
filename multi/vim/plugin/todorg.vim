" Use markdown to make todos
"
" Name made more sense when I was using orgmode.

let s:todorg_plan_file = "~/plan.md"

exec "command! Todo split ". s:todorg_plan_file

function! s:NewTodo()
    if expand("%:p") != expand(s:todorg_plan_file)
		Todo
    endif

    " New task
	call append(line('$'), "* ")
	normal! G$
    startinsert!
endf
command! TodoNew call s:NewTodo()
