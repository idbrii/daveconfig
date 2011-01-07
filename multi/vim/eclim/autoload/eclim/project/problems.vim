" Author:  Eric Van Dewoestine
"
" Description: {{{
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

" Global variables {{{
  if !exists('g:EclimProblemsQuickFixOpen')
    let g:EclimProblemsQuickFixOpen = 'botright copen'
  endif
" }}}

" Script variables {{{
  let s:problems_command = '-command problems -p "<project>"'
" }}}

" Problems(project, open) {{{
function! eclim#project#problems#Problems(project, open)
  let project = a:project
  if project == ''
    let project = eclim#project#util#GetCurrentProjectName()
  endif
  if project == ''
    call eclim#project#util#UnableToDetermineProject()
    return
  endif

  let command = s:problems_command
  let command = substitute(command, '<project>', project, '')
  let result = eclim#ExecuteEclim(command)
  let errors = []
  if result =~ '|'
    let errors = eclim#util#ParseLocationEntries(
          \ split(result, '\n'), g:EclimValidateSortResults)
  endif

  let action = eclim#project#problems#IsProblemsList() ? 'r' : ' '
  call eclim#util#SetQuickfixList(errors, action)

  " generate a 'signature' to distinguish the problems list from other qf
  " lists.
  let s:eclim_problems_sig = s:QuickfixSignature()

  if a:open
    exec g:EclimProblemsQuickFixOpen
  endif
endfunction " }}}

" ProblemsUpdate() {{{
function! eclim#project#problems#ProblemsUpdate()
  if g:EclimProjectProblemsUpdateOnSave &&
   \ eclim#project#problems#IsProblemsList()
    call eclim#project#problems#Problems('', 0)
  endif
endfunction " }}}

" IsProblemsList() {{{
function! eclim#project#problems#IsProblemsList()
  " if available, compare the problems signature against the signature of
  " the current list to see if we are now on the problems list, probably via
  " :colder or :cnewer.
  if exists('s:eclim_problems_sig')
    return s:QuickfixSignature() == s:eclim_problems_sig
  endif
  return 0
endfunction " }}}

" s:QuickfixSignature() {{{
function! s:QuickfixSignature()
  let qflist = getqflist()
  let len = len(qflist)
  return {
      \ 'len': len,
      \ 'first': len > 0 ? (qflist[0]['bufnr'] . ':' . qflist[0]['text']) : '',
      \ 'last': len > 0 ? (qflist[-1]['bufnr'] . ':' . qflist[-1]['text']) : ''
    \ }
endfunction " }}}

" vim:ft=vim:fdm=marker
