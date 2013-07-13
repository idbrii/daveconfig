" Often useful for picking out the this pointer and parameters.
function! vshelp#guess_correct_pointer()
	%smagic/\v(.\u{-}.=.\x+) /\1/g
	" Heap pointers on my platform start with the same bitpattern, so they're
	" easy to identify.
	v/07FF/d
	%sort /=/u
endf
