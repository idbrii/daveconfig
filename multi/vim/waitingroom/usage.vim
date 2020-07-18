" https://www.reddit.com/r/vim/comments/hszf0n/vim_histogram_of_commands/
function! GetCommandFrequency()
    " Be sure to change viminfo path if you put yours elsewhere (like nvim's
    " shada or my vim-cache). 'viminfofile' isn't helpful and I don't want to
    " parse 'viminfo' for n.
    .! grep -e"^:"  ~/.vim-cache/viminfo
    %v/^:/d
    %sm/\v^:(silent|verb\w*) /:
    %sm,[ /].*
    %sm/^:..,../:
    %sm/^:%/:
    %g/\v^:?\s*$/d
    %sort
    %g/^:\W/d
    %! uniq -c
    %sort n
    " Ignore single use items
    %g/   1 :/d
    10,$-10delete
    0put ='Bottom (but more than once) usage:'
    10put ='Top usage:'
    $put ='out of total non-unique commands'
    $put =''
    $! grep -e"^:"  ~/.vim-cache/viminfo | wc -l
    " Indent for posting to reddit.
    exec "norm! gg0\<C-v>GI    "
endf
