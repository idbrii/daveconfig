" Ale general {{{1

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 1000

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
let g:ale_linters = {
            \ 'cs': [
            \       'OmniSharp',
            \       'mcs',
            \   ]
            \ }

" Python {{{1

let s:python_exe = ''
for p in ['python', 'python3']
    if has(p)
        let s:python_exe = p
        break
    endif
endfor

" Install: AsyncPython -m pip install --user flake8
let g:ale_python_flake8_executable = s:python_exe
let g:ale_python_flake8_options = '-m flake8'

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


" Luacheck {{{1
let g:ale_lua_luacheck_options = ''

" Warning suppression {{{2
" See http://luacheck.readthedocs.io/en/stable/warnings.html for list.

" We have too much whitespace to manage.
let g:ale_lua_luacheck_options .= ' --ignore 611' "	A line consists of nothing but whitespace.
let g:ale_lua_luacheck_options .= ' --ignore 612' "	A line contains trailing whitespace.
" I like to do `local a = nil`
let g:ale_lua_luacheck_options .= ' --ignore 311' "	Value assigned to a local variable is unused.

" luacheck doesn't know about our globals, so ignore interactions with them.
"let g:ale_lua_luacheck_options .= ' --ignore 111' "	Setting an undefined global variable.
"let g:ale_lua_luacheck_options .= ' --ignore 112' "	Mutating an undefined global variable.
" I want 113 enabled to catch typos in variable names.
"let g:ale_lua_luacheck_options .= ' --ignore 113' "	Accessing an undefined global variable.
let g:ale_lua_luacheck_options .= ' --ignore 142' "	Setting an undefined field of a global variable.
let g:ale_lua_luacheck_options .= ' --ignore 143' "	Accessing an undefined field of a global variable.

" All options {{{2
" Get this: https://raw.githubusercontent.com/mpeterv/luacheck/master/docsrc/cli.rst
" Run this: %sm/\v^"``.*(--[^`]+)``/"let g:ale_lua_luacheck_options .= ' \1'                    "
"======================================= ================================================================================
"Option                                  Meaning
"======================================= ================================================================================
"let g:ale_lua_luacheck_options .= ' --no-global'                    "                    Filter out warnings related to global variables.
"let g:ale_lua_luacheck_options .= ' --no-unused'                    "                    Filter out warnings related to unused variables and values.
"let g:ale_lua_luacheck_options .= ' --no-redefined'                    "                 Filter out warnings related to redefined variables.
let g:ale_lua_luacheck_options .= ' --no-unused-args'                    "               Filter out warnings related to unused arguments and loop variables.
let g:ale_lua_luacheck_options .= ' --no-unused-secondaries'                    "        Filter out warnings related to unused variables set together with used ones.
"
"                                        See :ref:`secondaryvaluesandvariables`
"let g:ale_lua_luacheck_options .= ' --no-self'                    "                           Filter out warnings related to implicit ``self`` argument.
let g:ale_lua_luacheck_options .= ' --std lua51'
"let g:ale_lua_luacheck_options .= ' --std <std>'                    "                         Set standard globals. ``<std>`` can be one of:
"
"                                        * ``lua51`` - globals of Lua 5.1 without deprecated ones;
"                                        * ``lua51c`` - globals of Lua 5.1;
"                                        * ``lua52`` - globals of Lua 5.2;
"                                        * ``lua52c`` - globals of Lua 5.2 compiled with LUA_COMPAT_ALL;
"                                        * ``lua53`` - globals of Lua 5.3;
"                                        * ``lua53c`` - globals of Lua 5.3 compiled with LUA_COMPAT_5_2;
"                                        * ``luajit`` - globals of LuaJIT 2.0;
"                                        * ``ngx_lua`` - globals of Openresty `lua-nginx-module <https://github.com/openresty/lua-nginx-module>`_ with LuaJIT 2.0;
"                                        * ``min`` - intersection of globals of Lua 5.1, Lua 5.2, Lua 5.3 and LuaJIT 2.0;
"                                        * ``max`` - union of globals of Lua 5.1, Lua 5.2, Lua 5.3 and LuaJIT 2.0;
"                                        * ``_G``  (default) - same as ``lua51c``, ``lua52c``, ``lua53c``, or ``luajit`` depending on version of Lua used
"                                          to run ``luacheck`` or same as ``max`` if couldn't detect the version;
"                                        * ``love`` - globals added by `LÖVE <https://love2d.org>`_ (love2d);
"                                        * ``busted`` - globals added by Busted 2.0;
"                                        * ``rockspec`` - globals allowed in rockspecs;
"                                        * ``none`` - no standard globals.
"
"                                        See :ref:`stds`
"let g:ale_lua_luacheck_options .= ' --globals [<name>] ...'                    "              Add custom global variables or fields on top of standard ones. See :ref:`fields`
"let g:ale_lua_luacheck_options .= ' --read-globals [<name>] ...'                    "         Add read-only global variables or fields.
"let g:ale_lua_luacheck_options .= ' --new-globals [<name>] ...'                    "          Set custom global variables or fields. Removes custom globals added previously.
"let g:ale_lua_luacheck_options .= ' --new-read-globals [<name>] ...'                    "     Set read-only global variables or fields. Removes read-only globals added previously.
"let g:ale_lua_luacheck_options .= ' --not-globals [<name>] ...'                    "          Remove custom and standard global variables or fields.
"let g:ale_lua_luacheck_options .= ' --std max+love'                    ".
"let g:ale_lua_luacheck_options .= ' --allow-defined'                    "                Allow defining globals implicitly by setting them.
"
"                                        See :ref:`implicitlydefinedglobals`
let g:ale_lua_luacheck_options .= ' --allow-defined-top'                    "            Allow defining globals implicitly by setting them in the top level scope.
"
"                                        See :ref:`implicitlydefinedglobals`
"let g:ale_lua_luacheck_options .= ' --module'                    "                       Limit visibility of implicitly defined globals to their files.
"
"                                        See :ref:`modules`
"let g:ale_lua_luacheck_options .= ' --max-line-length <length'                    "           Set maximum allowed line length (default: 120).
let g:ale_lua_luacheck_options .= ' --no-max-line-length'                    "                Do not limit line length.
"let g:ale_lua_luacheck_options .= ' --max-code-line-length <length'                    "      Set maximum allowed length for lines ending with code (default: 120).
"let g:ale_lua_luacheck_options .= ' --no-max-code-line-length'                    "           Do not limit code line length.
"let g:ale_lua_luacheck_options .= ' --max-string-line-length <length'                    "    Set maximum allowed length for lines within a string (default: 120).
"let g:ale_lua_luacheck_options .= ' --no-max-string-line-length'                    "         Do not limit string line length.
"let g:ale_lua_luacheck_options .= ' --max-comment-line-length <length'                    "   Set maximum allowed length for comment lines (default: 120).
"let g:ale_lua_luacheck_options .= ' --no-max-comment-line-length'                    "        Do not limit comment line length.
"let g:ale_lua_luacheck_options .= ' --ignore | -i <patt> [<patt>] ...'                    "   Filter out warnings matching patterns.
"let g:ale_lua_luacheck_options .= ' --enable | -e <patt> [<patt>] ...'                    "   Do not filter out warnings matching patterns.
"let g:ale_lua_luacheck_options .= ' --only | -o <patt> [<patt>] ...'                    "     Filter out warnings not matching patterns.
"let g:ale_lua_luacheck_options .= ' --no-inline'                    "                         Disable inline options.
"let g:ale_lua_luacheck_options .= ' --config <config>'                    "                   Path to custom configuration file (default: ``.luacheckrc``).
"let g:ale_lua_luacheck_options .= ' --no-config'                    "                         Do not look up custom configuration file.
"let g:ale_lua_luacheck_options .= ' --[no-]config'                    " is not used and ``.luacheckrc`` is not found.
"
"                                        Default global location is:
"
"                                        * ``%LOCALAPPDATA%\Luacheck\.luacheckrc`` on Windows;
"                                        * ``~/Library/Application Support/Luacheck/.luacheckrc`` on OS X/macOS;
"                                        * ``$XDG_CONFIG_HOME/luacheck/.luacheckrc`` or ``~/.config/luacheck/.luacheckrc`` on other systems.
"let g:ale_lua_luacheck_options .= ' --no-default-config'                    "                 Do not use fallback configuration file.
"let g:ale_lua_luacheck_options .= ' --filename <filename>'                    "               Use another filename in output, for selecting
"                                        configuration overrides and for file filtering.
"let g:ale_lua_luacheck_options .= ' --exclude-files <glob> [<glob>] ...'                    " Do not check files matching these globbing patterns. Recursive globs such as ``**/*.lua`` are supported.
"let g:ale_lua_luacheck_options .= ' --include-files <glob> [<glob>] ...'                    " Do not check files not matching these globbing patterns.
"let g:ale_lua_luacheck_options .= ' --cache [<cache>]'                    "                   Path to cache file. (default: ``.luacheckcache``). See :ref:`cache`
"let g:ale_lua_luacheck_options .= ' --no-cache'                    "                          Do not use cache.
"let g:ale_lua_luacheck_options .= ' --jobs'                    "                         Check ``<jobs>`` files in parallel. Requires `LuaLanes <http://cmr.github.io/lanes/>`_.
"                                        Default number of jobs is set to number of available processing units.
"let g:ale_lua_luacheck_options .= ' --formatter <formatter>'                    "             Use custom formatter. ``<formatter>`` must be a module name or one of:
"
"                                        * ``TAP`` - Test Anything Protocol formatter;
"                                        * ``JUnit`` - JUnit XML formatter;
"                                        * ``plain`` - simple warning-per-line formatter;
"                                        * ``default`` - standard formatter.
"let g:ale_lua_luacheck_options .= ' --quiet'                    "                        Suppress report output for files without warnings.
"
"                                        * ``-qq`` - Suppress output of warnings.
"                                        * ``-qqq`` - Only output summary.
"let g:ale_lua_luacheck_options .= ' --codes'                    "                             Show warning codes.
"let g:ale_lua_luacheck_options .= ' --ranges'                    "                            Show ranges of columns related to warnings.
"let g:ale_lua_luacheck_options .= ' --no-color'                    "                          Do not colorize output.
"let g:ale_lua_luacheck_options .= ' --version'                    "                      Show version of Luacheck and its dependencies and exit.
"let g:ale_lua_luacheck_options .= ' --help'                    "                         Show help and exit.
"======================================= ==================================
