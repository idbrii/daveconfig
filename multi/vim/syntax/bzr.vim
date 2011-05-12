" Vim syntax file
" Language:	Bazaar-NG (bzr) commit file
" Maintainer:	Adeodato Simó <dato@net.com.org.es>
" BranchURL:	http://people.debian.org/~adeodato/code/bzr/bzr-vim
" Based On:	svn.vim by Dmitry Vasiliev
" vim:et ts=2 sw=2 sts=2

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match  bzrDelimiter	"^-\{10,} .* -\{10,}$"
syn match  bzrDelimiter	"^# start .*"
syn match  bzrAdded	"^added:$"
syn match  bzrRemoved	"^removed:$"
syn match  bzrModified	"^modified:$"
syn match  bzrRenamed	"^renamed:$"
syn match  bzrUnkown	"^unknown:$"
syn match   gitcommitFirstLine	"\%^[^#].*"  nextgroup=gitcommitBlank skipnl
syn match   gitcommitSummary	"^.\{0,50\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
syn match   gitcommitOverflow	".*" contained contains=@Spell
syn match   gitcommitBlank	"^[^#].*" contained contains=@Spell

syn region  bzrLogDiff	start="^=== " end="\%$\|^# start " contains=@diff
syn include @diff	syntax/diff.vim
unlet b:current_syntax

syn sync clear
syn sync match bzrSync	grouphere bzrLogDiff "^# start diff"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already.
" For version 5.8 and later: only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_bzr_syn_inits")
  if version <= 508
    let did_bzr_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink bzrDelimiter	Comment
  HiLink bzrAdded	diffAdded
  HiLink bzrRemoved	diffRemoved
  HiLink bzrModified	diffFile
  HiLink bzrRenamed	diffOnly
  HiLink bzrUnkown	diffLine
  HiLink gitcommitSummary		Keyword
  "HiLink gitcommitOverflow  Error
  HiLink gitcommitBlank     Error

  delcommand HiLink
endif

let b:current_syntax = "bzrlog"
