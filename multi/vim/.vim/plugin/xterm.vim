" Hacks to make terminal vim more usable

if &term =~ "xterm"

    " Use a blue cursor for insert mode
    " Assumes default cursor is white
    let &t_SI = "\<Esc>]12;blue\x7"
    let &t_EI = "\<Esc>]12;white\x7"

endif
