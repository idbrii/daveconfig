*I assume your plugin is named wubwub. Replace as appropriate.*

# Writing a plugin in vimscript

* Write your API in wubwub/plugin/wubwub.vim and wubwub/ftplugin/wubwub.vim as appropriate
 * `plugin` for plugins that affect all buffers
 * `ftplugin` for plugins that affect specific filetypes
* Write your code in wubwub/autoload/wubwub.vim
* Put a load guard in your API files to prevent reloading:

    if exists('loaded_wubwub') || &cp || version < 700
        finish
    endif
    let loaded_wubwub = 1

* Sometimes you want code to be loaded multiple times in an ftplugin (like buffer/window-local options or mappings), but for commands and global mappings you do not.
* Always wrap mappings in regular buffers with `no_plugin_maps` and `wubwub_no_mappings`:

	if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
            \ (! exists("g:wubwub_no_mappings") || ! g:wubwub_no_mappings)

 * This doesn't include special buffers that don't have editable text (like the Gstatus and Gblame buffers in fugitive).
 * These options make it easier for users who prefer to have complete control over their mappings.
 * The `wubwub_no_mappings` option is especially useful when you define multiple mappings and a user only wants to use one of them.
* Use `<Plug>` and [parenthesize <Plug> map names](http://stackoverflow.com/questions/13688022/what-is-the-reason-to-parenthesize-plug-map-names) to prevent delays.


# Writing a plugin in python

## Where do I put my python code?

Vim will include python2, python3, or pythonx directories in your python path.

    mkdir -p ~/.vim/bundle/wubwub/pythonx
    echo "print 'hi there'" > ~/.vim/bundle/wubwub/pythonx/hello.py
    gvim +"py import hello"


## Where do I put configuration?

In your vimrc.

    echo "let g:wubwub_name = 'idbrii'" >> ~/.vimrc
    cat << EOF > ~/.vim/bundle/wubwub/pythonx/hello.py
    import vim
    print vim.vars["wubwub_name"]
    EOF
    gvim +"py import hello"

You might be tempted to use configparser, but that's not a vim-friendly way of configuring since people can't just configure from their pre-existing config files. Also, you have to figure out where on disk the config file should be located!


## How can I create commands that pass data to python?

This is the trickiest part.

At the first level, we can create a function that takes an argument.

    cat << EOF > ~/.vim/bundle/wubwub/pythonx/hello.py
    import vim
    def f(text):
        print text +' woohoo'
    EOF
    gvim +"py import hello" +"execute 'py hello.f(\" '. g:wubwub_name .' \")'"

That's pretty awkward. I don't know the best way to call python functions with arguments. It's probably best to try to make your interface as tight as possible and only pass args when necessary.

    # ~/.vim/bundle/wubwub/pythonx/hello.py
    def action(args):
        for a in args:
			print a

    def action_api():
        args = vim.vars["wubwub_args"]
        action(args)

    # ~/.vim/bundle/wubwub/plugin/hello.vim
    function! Action(...)
        let g:wubwub_args = a:000
        python import hello
        python hello.action_api()
    endfunction
    command! -nargs=* Action call Action(<f-args>)

    gvim +"py import hello" +"Action do some stuff"

If you know any good python plugins that provide commands, you should have a look at how they work (I can't think of any).


## How do I ...

Try reading through *all* of `:help if_pyth`.

## Alternatives

You could use [snake](https://github.com/amoffat/snake) to make pythonic vim plugins (with less vimscript required), but it's mostly aimed at extending your vimrc.
