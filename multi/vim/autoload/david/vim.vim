
" Guess the file that defined the input symbol and use Vopen (vim-scriptease)
" to open it.
function! david#vim#GotoFile(symbol)
    let segments = split(a:symbol, '#')
    if len(segments) > 1
        " Autoload files are easy. Like asynccommand#run
        let function = segments[-1]
        let segments = segments[:-2]
        let path = 'autoload/'. join(segments, '/') .'.vim'
    else
        " Some kind of variable?
        let segments = split(a:symbol, '_')
        if len(segments) > 1
            if segments[0] == "loaded"
                " Something like like g:loaded_asynccommand
                let pluginname = join(segments[1:], '_')
            else
                " Something like g:asynccommand_statusline_autohide?
                let pluginname = segments[0]
            endif
            let path = 'plugin/'. pluginname .'.vim'
            exec 'Vopen '. path
        else
            " Might be an actual filename
            normal! gf
            return
        endif
    endif

    exec 'Vopen '. path
    let @/ = a:symbol
    " Normal search (for variables and easy repeat searching).
    normal! ggn
    " Declaration search (for functions).
    call search('function[! ]*'. a:symbol .'(')
endf
