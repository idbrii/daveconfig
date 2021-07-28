" Maps {{{1

nnoremap <unique> <Leader>if :<C-u>ALEFix<CR>

" Ale general {{{1

let g:ale_linters = {}
let g:ale_fixers = {}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 1000

" Use ALEPopulateQuickfix instead.
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0

" I've configured a bunch of linters here, so don't make me do it again.
let g:lsp_ale_auto_enable_linter = 0

" C++ {{{1
let g:ale_linters.cpp = [
            \       'vim-lsp',
            \   ]

let g:ale_fixers.cpp = []
" clang-format's default is wild. See ~/.vim/local_templates/clang-format.
call add(g:ale_fixers.cpp, 'clang-format')
call add(g:ale_fixers.cpp, 'clangtidy')
call add(g:ale_fixers.cpp, 'trim_whitespace')

" C# {{{1

" Disabling mcsc to see if that makes vim more responsive. I've got omnisharp
" so that should be equivalent. I'm not sure mcs adds much (it's for syntax
" checking whereas OmniSharp is semantic checking), but it doesn't seem to
" cause problems.
"
" I often have incorrect double definition (after moving) or not defined
" (after adding something new) errors. I have to restart omnisharp servers to
" fix (sometimes that doesn't work). Suggested fix is to get Unity to regen
" the sln:
" https://github.com/OmniSharp/omnisharp-vim/issues/405#issuecomment-419291942
" If using mono, then add 'mcs' linter. Otherwise, exclude it because mono is missing
" later C# features and will give false positives.
let g:ale_linters.cs = [
            \       'OmniSharp',
            \   ]

" Python {{{1

let s:python_exe = ''
for p in ['python3', 'python']
    if has(p)
        let s:python_exe = p
        break
    endif
endfor

" Language server is probably best, but mypy does type annotation checking.

let g:ale_linters.python = [
            \     'flake8',
            \     'mypy',
            \     'pylint'
            \ ]

" pyls -> :LspInstallServer
let g:ale_python_pyls_executable = expand('~/.vim/bundle/lsp-settings/servers/pyls/venv/Scripts/pyls')

" Install: AsyncPython -m pip install --user flake8
let g:ale_python_flake8_executable = s:python_exe
let g:ale_python_flake8_options = '-m flake8'

let g:ale_python_mypy_options = printf('--cache-dir %s/mypy_cache/', g:david_cache_root)

" Expansive set for my code.
let g:ale_python_flake8_options .= ' --ignore E302' " expected 2 blank lines, found 1
let g:ale_python_flake8_options .= ',E501' " line too long
let g:ale_python_flake8_options .= ',E225' " missing whitespace around operator -- I like 'sdf'+ val

" Minimal set for other people's code.
" https://pycodestyle.readthedocs.io/en/latest/intro.html#error-codes
" Things that are likely bugs:
let g:ale_python_flake8_options .= ' --select C90'  " mccabe
let g:ale_python_flake8_options .= ',F'             " flake errors
let g:ale_python_flake8_options .= ',E999'          " SyntaxError
let g:ale_python_flake8_options .= ',E7'            " Statement
let g:ale_python_flake8_options .= ',E9'            " Runtime error
let g:ale_python_flake8_options .= ',W6'            " Deprecation
" Worthwhile style:
let g:ale_python_flake8_options .= ',E1'            " Indentation
let g:ale_python_flake8_options .= ',W291'          " trailing whitespace
let g:ale_python_flake8_options .= ',W293'          " blank line contains whitespace

" Fall back on syntax if python isn't setup (unfortunately, we can't really
" check for flake8's existence).
let g:python_highlight_space_errors = executable(g:ale_python_flake8_executable) == 0

" Install: AsyncPython -m pip install --user pylint
let g:ale_python_pylint_executable = '' "s:python_exe
let g:ale_python_pylint_options = '-m pylint -rcfile ~/data/settings/daveconfig/multi/python/pylint.rc'
" The virtualenv detection needs to be disabled.
let g:ale_python_pylint_use_global = 0


let g:ale_fixers.python = [
            \     'black',
            \     'isort',
            \ ]

" black -> :! python3 -m pip install black

" Use Vertical Hanging Indent
let g:ale_python_isort_options = '--multi-line 3 --use-parentheses'

" Rust {{{1
let g:ale_linters.rust = [
            \       'rls',
            \   ]

let g:ale_fixers.rust = [
            \       'rustfmt',
            \       'remove_trailing_lines',
            \       'trim_whitespace',
            \   ]

" golang {{{1
let g:ale_fixers.go = [
            \     'gofmt',
            \     'goimports',
            \ ]

" Luacheck {{{1
let g:ale_fixers.lua = [
            \     'trim_whitespace',
            \ ]

let g:ale_linters.lua = [
            \       'luac',
            \       'luacheck',
            \       'vim-lsp',
            \   ]

let s:rc = david#path#to_unix('~/data/settings/daveconfig/multi/vim/bundle/work/scripts/luacheckrc')
if !filereadable(s:rc)
    let s:rc = david#path#to_unix('~/data/settings/daveconfig/multi/lua/luacheckrc')
endif

let g:ale_lua_luacheck_options = ''
let g:ale_lua_luacheck_options .= ' --default-config ' .. s:rc

