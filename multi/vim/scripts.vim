if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif
let first_line = getline(1)
if first_line =~ '^# A Perforce '
  setfiletype perforce
elseif first_line =~ '^!_TAG_FILE_FORMAT'
  setfiletype tags
endif
