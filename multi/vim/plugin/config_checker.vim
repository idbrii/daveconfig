let g:ale_lua_luacheck_options = ''
" Get this: https://raw.githubusercontent.com/mpeterv/luacheck/master/docsrc/cli.rst
" Run this: %sm/\v^"``.*(--[^`]+)``/"let g:ale_lua_luacheck_options .= ' \1'                    "
"======================================= ================================================================================
"Option                                  Meaning
"======================================= ================================================================================
"let g:ale_lua_luacheck_options .= ' --no-global'                    "                    Filter out warnings related to global variables.
"let g:ale_lua_luacheck_options .= ' --no-unused'                    "                    Filter out warnings related to unused variables and values.
"let g:ale_lua_luacheck_options .= ' --no-redefined'                    "                 Filter out warnings related to redefined variables.
"let g:ale_lua_luacheck_options .= ' --no-unused-args'                    "               Filter out warnings related to unused arguments and loop variables.
"let g:ale_lua_luacheck_options .= ' --no-unused-secondaries'                    "        Filter out warnings related to unused variables set together with used ones.
"
"                                        See :ref:`secondaryvaluesandvariables`
"let g:ale_lua_luacheck_options .= ' --no-self'                    "                           Filter out warnings related to implicit ``self`` argument.
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
"let g:ale_lua_luacheck_options .= ' --std max'                    ".
"let g:ale_lua_luacheck_options .= ' --allow-defined'                    "                Allow defining globals implicitly by setting them.
"
"                                        See :ref:`implicitlydefinedglobals`
"let g:ale_lua_luacheck_options .= ' --allow-defined-top'                    "            Allow defining globals implicitly by setting them in the top level scope.
"
"                                        See :ref:`implicitlydefinedglobals`
"let g:ale_lua_luacheck_options .= ' --module'                    "                       Limit visibility of implicitly defined globals to their files.
"
"                                        See :ref:`modules`
"let g:ale_lua_luacheck_options .= ' --max-line-length <length'                    "           Set maximum allowed line length (default: 120).
"let g:ale_lua_luacheck_options .= ' --no-max-line-length'                    "                Do not limit line length.
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
