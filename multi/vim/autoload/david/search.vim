
" Find containing scope, echo it, and return its line number. Some languages
" have different levels of relevant scope, so the number of indents is a
" parameter.
" Assumes lines ending with ; or , are not relevant to scope.
function! david#search#FindScope(max_indents)
    let last_search=@/

    let space_indent = repeat(' ', &shiftwidth)
    let query = '\v^('. space_indent .'|\t){0,'. a:max_indents .'}\w.*[^ \t;,]\s*$'
    let line = search(query, 'bWn')
    echo getline(line)

    let @/ = last_search

    " Also highlight current scope.
    call matchup#matchparen#highlight_surrounding()

    return line
endf

function! david#search#FindUnusedModules() abort
    " Find lua modules that aren't `require`d anywhere. Great for cleaning up
    " love2d superprojects before publishing to limit to the actual project.

    let lazyredraw_bak = &lazyredraw
    let &lazyredraw = 1

    tabnew

    let allow_async_bak = g:notgrep_allow_async
    let g:notgrep_allow_async = 0


    NotGrep \brequire\b

    let g:notgrep_allow_async = allow_async_bak

    copen
    %yank c
    Scratch
    0put c
    %v/\.lua|/d
    %g/| --/d
    %v/\v.*\s*<require\s*\(?(["'])(.*)\1\)?.*/d
    %sm//\2
    %s,\.,/,g
    %SearchForAnyLine
    let @c = @/
    Bwipeout
    " Special case some massive libraries
    let massive = { 'cpml' : 0, 'pl' : 0 }
    for key in keys(massive)
        let massive[key] = search('\v<'.. key ..'>', 'nw') > 0
    endfor

    cnext
    EditUpwards filelist
    v/^src.*lua$/d _
    let @/ = @c
    g//d _
    for key in keys(massive)
        if massive[key]
            exec "g,\\v<lib>.".. key ..",d _"
        endif
    endfor

    %argdelete
    g/^/exec 'argadd' getline('.')

    edit!
    tabclose

    nnoremap \\ :Gremo <Bar> next<CR>

    let &lazyredraw = lazyredraw_bak
    redraw

    echo "Unused modules loaded to arglist:"
    args
    echo 'Use \\ to delete current file and check next.'
endf
