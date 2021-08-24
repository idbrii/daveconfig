" Vim compiler file to build markdown with pandoc
" Compiler:    pandoc

if exists("current_compiler")
  finish
endif

let current_compiler = "pandoc"

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=pandoc\ -o\ %.html\ %

let &cpo = s:cpo_save
unlet s:cpo_save
