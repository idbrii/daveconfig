" Compiler:	python
" Last Change:	2013-02-16

if exists("current_compiler")
  finish
endif
let current_compiler = "python"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Options:
"   -t     : issue warnings about inconsistent tab usage (-tt: issue errors)
"
" Consider:
"   -3     : warn about Python 3.x incompatibilities that 2to3 cannot
"   trivially fix
"
CompilerSet makeprg=python\ -t\ %

" Pull the full stacktrace into qf so you can step through the error
" locations.
CompilerSet errorformat=
            \%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,
            \%Z\ \ \ \ %m


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:

