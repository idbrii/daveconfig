" Compiler:	py_compile
" Last Change:	2013-02-17

if exists("current_compiler")
  finish
endif
let current_compiler = "py_compile"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"

CompilerSet errorformat=
            \SyntaxError:\ ('invalid\ syntax'\\,\ ('%f'\\,\ %l\\,\ %c\\,\ %m))


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
