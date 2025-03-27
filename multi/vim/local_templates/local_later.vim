" Search for a file that indicates the root of this kind of project and switch
" to it.
function! s:find_folder_for_marker(marker_file, proj_switcher) abort
    let proj = findfile(a:marker_file, '.;')
    if !empty(proj)
        " Use project folder name as session name.
        let proj = fnamemodify(proj, ":p:h:t")
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

        "~ elseif s:find_folder_for_marker('main.lua', 'ProjectSwitchLove')
        elseif !empty(findfile('main.lua', '.;'))
            " TODO: Not using find_folder_for_marker because love project
            " doesn't support arguments.
            ProjectSwitchLove

        elseif s:find_folder_for_marker('project.godot', 'ProjectSwitchGodot')

        elseif s:find_folder_for_marker('Cargo.toml', 'ProjectSwitchRust')

        elseif !empty(finddir('Library', '.;')) && s:find_folder_for_marker('Assembly-CSharp.csproj', 'ProjectSwitchUnity')

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
