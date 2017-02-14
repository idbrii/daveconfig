" Bisect a vimscript file to find a bug.
"
" Automatically inserts `finish` to prevent later statements from having an
" impact. This is most useful on vimrc-type files of settings rather than
" files full of functions.
"
"

" Example use: File with 200 lines.
" Start at 200 / 2 = 100
" g 100 + 200 / 4 = 150
"   g 150 + 200 / 8 = 175
"   b 150 - 200 / 8 = 125
" b 100 - 200 / 4
"   g 50 + 200 / 8 = 75
"   b 50 - 200 / 8 = 25

function! david#bisect#start()
    if !exists("g:BISECTVIMSCRIPT_NUM_DIVISIONS")
        " First time setup.

        " Using viminfo to pass data between iterations. We can't pass
        " this on cmdline, so we modify the vimrc. (TODO: Maybe can use rviminfo?)
        let g:BISECTVIMSCRIPT_VIMINFO = &viminfo
        split ~/.vimrc
        normal! ggO" viminfo modified by BisectVimscript
        normal! oset viminfo+=f1 viminfo+=!
        update
        close

        let g:BISECTVIMSCRIPT_NUM_DIVISIONS = 0

        let @+ = v:progname .' +"call david#bisect#start()" test-file'
        let @* = @+
        let @" = @+

        normal! gg
        mark B
        " The first line must be good or we're boned.
        call david#bisect#evaluate("good")
        echomsg "Quit vim and paste into terminal to re-open vim."

    else
        " Resuming bisection

        command! -nargs=1 BisectVimscript call david#bisect#evaluate(<q-args>)
        echomsg "Use `:BisectVimscript good` if everything works."
        echomsg "Use `:BisectVimscript bad` if it's still broken."
    endif
    
    command! -nargs=0 BisectStop call david#bisect#stop()
endf

" TODO: Move to a plugin file.
command! -nargs=0 BisectVimscript call david#bisect#start()

function! david#bisect#stop()
    if exists("g:BISECTVIMSCRIPT_VIMINFO")
        let &viminfo = g:BISECTVIMSCRIPT_VIMINFO
        silent! unlet g:BISECTVIMSCRIPT_VIMINFO
    endif 
    silent! unlet g:BISECTVIMSCRIPT_NUM_DIVISIONS
    silent! delcommand BisectStop
    silent! delcommand BisectVimscript
    command! -nargs=0 BisectVimscript call david#bisect#start()

    split ~/.vimrc
    normal! ggVj
    echomsg "Remove the automatic viminfo modifications."
endf

function! david#bisect#get_increment(num_divisions)
    let divisor = pow(2, a:num_divisions)
    let increments = float2nr(line('$') / divisor)
    " Ensure we move by at least one line.
    return max([increments, 1])
endf

function! david#bisect#evaluate(evaluation)
    if a:evaluation ==# "good"
        " Good means the problem occurred later in the file, so go forward.
        let bisect_increment = 1
    elseif a:evaluation ==# "bad"
        " Good means the problem was sourced, so go backward.
        let bisect_increment = -1
    else
        echoerr "Input 'good' or 'bad'"
        return
    endif

    " Go to our last location (in the bisected file).
    normal! g'B

    if g:BISECTVIMSCRIPT_NUM_DIVISIONS > 0
        " Only have something to undo after first division.
        normal! u
    endif

    let g:BISECTVIMSCRIPT_NUM_DIVISIONS += 1

    let bisect_last = line("'B")
    let bisect_increment = bisect_increment * david#bisect#get_increment(g:BISECTVIMSCRIPT_NUM_DIVISIONS)
    call cursor(bisect_last + bisect_increment, 0)
    mark B
    normal! ofinish
endf

