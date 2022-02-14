
" Remove autotrigger. This makes ultisnips spam errors if something goes
" wrong. I don't autotrigger snippets. Will fail if ultisnips didn't load.
silent! au! UltiSnips_AutoTrigger

" UltiSnipsEdit is bad number-choosing UI, changes path case, and shows files
" that don't exist. Use Vedit instead.
command! -bang UltiSnipsEdit call david#ultisnips#UltiSnipsEdit(<bang>0)
