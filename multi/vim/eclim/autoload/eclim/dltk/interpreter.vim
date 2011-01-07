" Author:  Eric Van Dewoestine
"
" Description: {{{
"   see http://eclim.org/vim/ruby/index.html
"
" License:
"
" Copyright (C) 2005 - 2009  Eric Van Dewoestine
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" }}}

" Script Variables {{{
  let s:command_interpreters = '-command dltk_interpreters -n <nature>'
  let s:command_interpreter_addremove =
    \ '-command dltk_<action>_interpreter -n <nature> -i "<path>"'
" }}}

" GetInterpreters(nature) {{{
function eclim#dltk#interpreter#GetInterpreters(nature)
  let command = s:command_interpreters
  let command = substitute(command, '<nature>', a:nature, '')
  let interpreters = split(eclim#ExecuteEclim(command), '\n')
  if len(interpreters) == 0 || (len(interpreters) == 1 && interpreters[0] == '0')
    return []
  endif

  call filter(interpreters, 'v:val =~ ".* - "')
  call map(interpreters, 'substitute(v:val, "\s*.\\{-} - \\(.*\\)", "\\1", "")')
  return interpreters
endfunction " }}}

" ListInterpreters(nature) {{{
function eclim#dltk#interpreter#ListInterpreters(nature)
  let command = s:command_interpreters
  let command = substitute(command, '<nature>', a:nature, '')
  let interpreters = split(eclim#ExecuteEclim(command), '\n')
  if len(interpreters) == 0
    call eclim#util#Echo("No interpreters.")
  endif
  if len(interpreters) == 1 && interpreters[0] == '0'
    return
  endif
  let result = substitute(join(interpreters, "\n"), "\t", '  ', 'g')
  call eclim#util#Echo(result)
endfunction " }}}

" AddInterpreter(nature, type, path) {{{
function eclim#dltk#interpreter#AddInterpreter(nature, type, path)
  return s:InterpreterAddRemove(a:nature, a:type, a:path, 'add')
endfunction " }}}

" RemoveInterpreter(nature, path) {{{
function eclim#dltk#interpreter#RemoveInterpreter(nature, path)
  return s:InterpreterAddRemove(a:nature, '', a:path, 'remove')
endfunction " }}}

" s:InterpreterAddRemove(nature, type, path, action) {{{
function s:InterpreterAddRemove(nature, type, path, action)
  let path = a:path
  let path = substitute(path, '\ ', ' ', 'g')
  let path = substitute(path, '\', '/', 'g')
  let command = s:command_interpreter_addremove
  let command = substitute(command, '<action>', a:action, '')
  let command = substitute(command, '<nature>', a:nature, '')
  let command = substitute(command, '<path>', path, '')
  if a:action == 'add'
    let command .= ' -t ' . a:type
  endif
  let result = eclim#ExecuteEclim(command)
  if result != '0'
    call eclim#util#Echo(result)
    return 1
  endif
  return 0
endfunction " }}}

" vim:ft=vim:fdm=marker
