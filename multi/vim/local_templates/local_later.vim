" Search for a file that indicates the root of this kind of project and switch
" to it.
function! s:find_folder_for_marker(marker_file, proj_switcher) abort
    if !empty(findfile(a:marker_file, '.;'))
        " Use project folder name as session name.
        let proj = findfile(a:marker_file, '.;')
        let proj = fnamemodify(proj, ":h:t")
        let g:snips_company = 'idbrii'
        exec a:proj_switcher proj
        return v:true
    end
    return v:false
endf

" For gamejam/personal.
if has('gui_running') && (v:servername == 'VIDE' || v:servername == 'localhost:8900')
    function! s:GuessProject() abort

        " Delete autocmd to prevent recursion.
        augroup local_later
            au!
        augroup END
        augroup! local_later


        if expand("%:p") =~# 'Project'
            ProjectSwitchProject

        elseif !empty(findfile('main.lua', '.;'))
            ProjectSwitchLove

        elseif s:find_folder_for_marker('project.godot', 'ProjectSwitchGodot')

        elseif s:find_folder_for_marker('Cargo.toml', 'ProjectSwitchRust')

        " TODO: an argument instead of being fixed on one project
        "~ elseif s:find_folder_for_marker('main.lua', 'ProjectSwitchLove')

        elseif !empty(finddir('Library', '.;'))
            ProjectSwitchUnityCurrent

        else
            " Current main project.
            ProjectSwitchProject
        endif
    endf

    " After my obsession session loads my most recent file, guess the project
    " based on that file.
    augroup local_later
        au!
        autocmd SessionLoadPost * call s:GuessProject()
    augroup END
endif
