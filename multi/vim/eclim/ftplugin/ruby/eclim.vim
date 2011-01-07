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

" Global Variables {{{

if !exists("g:EclimRubyValidate")
  let g:EclimRubyValidate = 1
endif

" }}}

" Options {{{

setlocal completefunc=eclim#ruby#complete#CodeComplete

" }}}

" Autocmds {{{

augroup eclim_ruby
  autocmd! BufWritePost <buffer>
  autocmd BufWritePost <buffer>
    \ call eclim#lang#UpdateSrcFile('ruby', g:EclimRubyValidate)
augroup END

" }}}

" Command Declarations {{{

command! -nargs=0 -buffer Validate :call eclim#lang#UpdateSrcFile('ruby', 1)

if !exists(":RubySearch")
  command -buffer -nargs=*
    \ -complete=customlist,eclim#ruby#search#CommandCompleteRubySearch
    \ RubySearch :call eclim#ruby#search#Search('<args>')
endif

if !exists(":RubySearchContext")
  command -buffer RubySearchContext :call eclim#ruby#search#SearchContext()
endif

if !exists(":RubyInterpreters")
  command -buffer RubyInterpreters
    \ :call eclim#dltk#interpreter#ListInterpreters('ruby')
  command -buffer -nargs=1 -complete=file
    \ RubyInterpreterAdd
    \ :call eclim#ruby#interpreter#AddInterpreter('<args>')
  command -buffer -nargs=1
    \ -complete=customlist,eclim#ruby#interpreter#CommandCompleteInterpreterPath
    \ RubyInterpreterRemove
    \ :call eclim#dltk#interpreter#RemoveInterpreter('ruby', '<args>')
endif

" }}}

" vim:ft=vim:fdm=marker
