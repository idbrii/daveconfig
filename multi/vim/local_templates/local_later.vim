
" For gamejam/personal.
if has('gui_running') && v:servername == 'VIDE'
    function! s:GuessProject() abort

        if expand("%:p") =~# 'Project'
            ProjectSwitchProject

        elseif !empty(findfile('main.lua', '.;'))
            ProjectSwitchLove

        elseif !empty(findfile('project.godot', '.;'))
            let g:snips_company = 'idbrii'
            ProjectSwitchGodot worldkit

        elseif !empty(finddir('Library', '.;'))
            ProjectSwitchUnityCurrent

        else
            " Current main project.
            ProjectSwitchProject
        endif


        augroup local_later
            au!
        augroup END
        augroup! local_later
    endf

    " After my obsession session loads my most recent file, guess the project
    " based on that file.
    augroup local_later
        au!
        autocmd SessionLoadPost * call s:GuessProject()
    augroup END
endif
