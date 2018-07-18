My Vim Philosophy
=================

I love using vim because it's so easy to automate. Configuring vim is
essentially programming in a slightly unfamiliar language with an obtuse
debugger. To help us all cope, I'm recording my guidelines for how to write
vimscript.


Help
====
The help system is fantastic and has `:help help-summary` to explain how to navigate and use it.

See also this [StackOverflow question and answer](http://stackoverflow.com/questions/25474313/how-do-i-find-out-what-a-vim-command-does) and this [reddit post](http://www.reddit.com/r/vim/comments/2eb82s/how_to_find_vimdoc_help/).


Basics
======

Use [vim-sensible](https://github.com/tpope/vim-sensible). You can tweak it by creating a ~/.vim/after/plugin/sensible.vim to overwrite settings, but think of it as the new vim settings. I test plugins assuming users have sensible installed.

Unfortunately, some releases of vim ship with a broken `K` command. Fortunately, [vim-scriptease](https://github.com/tpope/vim-scriptease) fixes it and super powers it. Anyone writing vimscript (which is any vim user) should use scriptease.

Edit plugin/sensible.vim, position the cursor on a setting you don't understand, and use `K` to open the corresponding help. Do this often so you can understand what things do and how vim works.


Plugins
=======

The best way to install plugins in vim is with a plugin manager. Avoid vimballs because they'll clutter your config and are hard to remove. Provide a path to :UseVimball to install in .vim/bundle/.

[pathogen](https://github.com/tpope/vim-pathogen) is great if you're a plugin developer, but you might want something like [git-submanage](https://github.com/idbrii/git-submanage) to deal with submodules. [ref](http://www.reddit.com/r/vim/comments/2oaujn/gitsubmanage_commit_your_updated_submodule_with_a/)

I like using pathogen because I get the same configuration on all of my machines and I store version information in my version control system (git). When I clone a new config, I get the same versions for each plugin that I have on my main machine and not the latest version (which sometimes have bugs, incompatibilities with other plugins, changes in functionality, or other surprises that I don't want to deal with when setting up a new machine). So I'm confident that everything works as I expect it.

As far as I understand, Vundle and Neobundle's BundleInstall commands install the latest version at the time of installation unless you use revision locks (where you store your desired version in your vimrc instead of storing version information in your version control system).

[ref](http://www.reddit.com/r/vim/comments/1w4udb/best_vim_plugin_manager/ceyzrws)
[ref](http://www.reddit.com/r/vim/comments/2tubi5/vundle_is_so_painless_compared_to_pathogen/co2yvpq)


Things to Avoid
===============

cabbrev is evil. (Examples: [1](http://www.reddit.com/r/vim/comments/2jl2g4/vim_settings_with_vundle/cldck9s) [2](http://www.reddit.com/r/vim/comments/24opqn/make_cnoremap_act_more_like_a_bash_alias/chbbmpj?context=10000)) Use :command or [cmdalias](http://www.vim.org/scripts/script.php?script_id=746) instead.

Use noremap instead of map. While you need to use map for `<Plug>`, using noremap for most maps will prevent recursive remapping.

Use nnoremap instead of noremap for Normal mode. Maps often only make sense in certain contexts. Usually your maps are only relevant in Normal xor Visual mode, so use the appropriate mode.

Use xnoremap instead of noremap for visual mode. Using xnoremap will only map it in Visual mode (and not Select mode which is something you won't realize you're using until it bites you or you're a master).

Use `<Plug>` if you want a unique prefix instead of an arbritrary string of characters. Using something like `nnoremap [unite] <C-Space>` to define a "namespace" for your Unite leader is a bad hack. If you happened to enter the keys `[unite]` in that sequence, vim would invoke `<C-Space>`. Instead, use `<Plug>(unite)`. It works the same except guaranteed not to match any input sequence. (And [parenthesize <Plug> map names](http://stackoverflow.com/questions/13688022/what-is-the-reason-to-parenthesize-plug-map-names) to prevent delays.)

Avoid mapping printable/whitespace characters in insert mode. This includes Leader mappings: they only work if you don't need to insert the leader key in your documents. You could argue that using `,` as leader means `<Leader>n` is an acceptable mapping and will never be encountered in your workflow, but one day you'll write a csv file and write `old_file,new_file,delta_size` and weirdness will occur and some characters will be missing (because your Leader map resolves to `,n` and that character sequence is contained in that input string).Instead, use meta key combinations for insert mode mappings. See `:help insert-index` for a list of vim's insert mode keys so you can determine which are unused. Mapping printable/whitespace characters in insert mode to anything but themselves (like the undobreaking `inoremap <CR> <C-G>u<CR>`) is like writing unsafe code because you can't currently perceive that future use case that would break it. Write robust code everywhere or start writing hatemail to your past self.

([ref](https://www.reddit.com/r/vim/comments/3jzzca/windows_10_and_the_leader_key/cuusmlj))


autoload
========

Use autoload (to reduce load times). Don't bother with "lazy loading" plugin managers. Just read the help for autoload and if plugins that don't need to be loaded on start are slow (using `--startuptime`), then file a bug.

[ref](http://www.reddit.com/r/vim/comments/2ukm62/script_roundup_enabler_vimstay/coaect8)


ftplugin
========
I prefer ftplugin over `autocmd FileType` because I think it's better programming:

* Organizes isolated code into separate files instead of one liners.
 * Most ftplugin code is irrelevant to other filetypes.
 * autocmds put everything on one line (separated by bars) or on multiple escaped lines which is harder to read.
 * ftplugins allow you to use files and folders to organize your code (~/.vim/ftplugin/python/rope.vim). Over time, the filetypes you use most will grow and organizing them into files will facilitate maintenance.
* Uses vim's system for filetype-specific configuration instead of setting up your own.
 * Vim's $VIMRUNTIME/ftplugin.vim uses autocmd FileType to run all the files in ftplugin. By registering your own handler, you're re-creating the built-in system. While it's not likely a performance problem for vim, creating many redundant handlers is a bad practice.
 * Allows you to use both .vim/ftplugin/ (on FileType) and .vim/after/ftplugin/ (after other ftplugins are loaded).

Obviously there are cases where autocmd FileType is useful: A plugin that works with all C-like languages (not just ones that use the c filetype) can use autocmd FileType instead of sticking a caller in many individual ftplugin files. But most uses of it should be replaced with ftplugin.

[ref](http://www.reddit.com/r/vim/comments/2v06d4/meaning_of_some_common_vimbootstrapcom_commands/codz83c?context=3)


New Languages
=============
When I get started with a new language, I need four core editor components to become productive:

* syntax highlighting
* code navigation (jump to definition, find references)
* completion
* build support (converting error messages and callstacks into quickfix locations)

For me this means:

* Getting a syntax file if (shock!) vim didn't come with one.
* ctags and cscope for almost all of my code navigation
* Finding a decent completion plugin. For languages it supports, I use the massive [eclim vim plugin](http://eclim.org/vim/python/index.html) (lets you use eclipse functionality like completion, tasks, finding files, syntax checking from within Vim). Since I already have Eclipse open for debugging, I don't mind the weight.
* I usually have to write my own compiler script to get builds working. I rarely find compiler scripts (see `:help :compiler`) and often people set them up to just check syntax instead of running from vim and parsing the callstack. Figuring out the efm is my least favourite part (I've never actually used scanf, so I haven't internalized the commands).

After I've got the basics (and I'm still enjoying working in the language), I get fancier:

* Mapping K to pull up language-specific documentation.
* Adding folding to the syntax file. (My default foldmethod is indent, which usually works, but syntax is better.)
* Interactive behavior with a [slime](https://github.com/jpalardy/vim-slime) or [screen](https://github.com/ervandew/screen) plugin to inject your code in a REPL running in a screen session.
* Auto-running unit tests ([like autonose](https://github.com/gfxmonk/autonose)). These tend to be super-language specific and the most integration I would do is a compiler script for their output. Also, I don't test as much as I should.

[ref](http://www.reddit.com/r/vim/comments/1424b3/what_do_you_need_mostfirst_when_starting_in_a_new/)


Building
========

Use :compiler to set up your build environment. It takes a lot of guess work out of the dreaded 'errorformat'. You can use an autocmd to automatically invoke it [like this](http://www.reddit.com/r/vim/comments/2rohxo/autorun_compiler/). Some compiler setups aren't built-in, but it's better to find and improve those than work without compiling.

Building from inside vim is great if you can swing it, but even if not you can use `:cgetfile` to load any file as error output. Using the quickfix window to navigate between errors is far superior to manual navigation.

As you start working on larger projects, I recommend investigating an async build plugin like [vim-dispatch](https://github.com/tpope/vim-dispatch) or [AsyncCommand](https://github.com/idbrii/AsyncCommand).


grep
====

Be careful with `$GREP_DEFAULT_OPTIONS`. See [vim-searchsavvy](https://github.com/idbrii/vim-searchsavvy/blob/master/plugin/smartgrep.vim#L13-L54) for why and a solution to make your grep fast like ack.

If you have a large codebase, try [codesearch](https://code.google.com/p/codesearch/). My [notgrep](https://github.com/idbrii/vim-notgrep) plugin integrates it into vim (and can be used with ack or other command line searchers).


Plugins
=======

Generally, you should install plugins to fill a need instead of just grabbing everything. As you push at the boundaries of what vim can do, you'll find plugins to expand your horizons. However, there are a few plugins that should come with vim by default:

* [vim-surround](https://github.com/tpope/vim-surround) which provides an operator to apply matched characters to a text-object to complement the text-object for text in matched characters.
* [vim-repeat](https://github.com/tpope/vim-repeat) to allow actions to support . repeating.

Some plugins just fit in so well to how vim already works:

* [vim-vinegar](https://github.com/tpope/vim-vinegar) makes using the built-in netrw a bit easier.
dirvish and open-browser replace netrw. Even better, replace netrw with [dirvish](https://github.com/justinmk/vim-dirvish) and [open-browser](https://github.com/tyru/open-browser.vim).
* [vim-speeddating](https://github.com/idbrii/vim-speeddating) isn't always useful, but since it just makes vim's `<C-a>`/`<C-x>` handle more types of numbers for incrementing you might as well have it.

Some plugins can change the way you use vim or just make it seem way more powerful:

* Source control integration. [vim-fugitive](https://github.com/tpope/vim-fugitive) is great, but only good for git. Typically each source control system has one leading plugin.
* [quickfix-reflector](https://github.com/stefandtw/quickfix-reflector.vim)
* [gundo.vim](https://github.com/sjl/gundo.vim) or [undotree](https://github.com/mbbill/undotree)
* [renamer.vim](https://github.com/idbrii/renamer.vim)
* A fuzzy finder like [unite.vim](https://github.com/Shougo/unite.vim) (incredibly flexible and works as a incremental find interface for anything) or [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) (faster but has bugs).
* [ultisnips](https://github.com/SirVer/ultisnips)
* [vim-easy-align](https://github.com/junegunn/vim-easy-align)

Sometimes you just want a fancy [statusline](https://github.com/bling/vim-airline) to remind you what mode you're in, to make the current window stand out, or to show you pretty colours.


Splits
======

One of the powerful features of Vim is splitting windows. [golden-ratio](https://github.com/idbrii/golden-ratio) makes it easy to give more space for the current split. I think it's only usable in manual mode:

    " Golden-ratio
    " Don't resize automatically.
    let g:golden_ratio_autocommand = 0

    " Mnemonic: - is next to =, but instead of resizing equally, all windows are
    " resized to focus on the current.
    nmap <C-w>- <Plug>(golden_ratio_resize)
    " Fill screen with current window.
    nnoremap <C-w>+ <C-w><Bar><C-w>_


You're also well-served by a good scratch plugin for writing junk notes or formatting external text. [itchy](https://github.com/idbrii/itchy.vim) will automatically split in the direction you want (so you can see the most text).


Diff and Merge
==============
vim's diff mode is great once you get used to it. I wrote [vim-diffusable](https://github.com/idbrii/vim-diffusable) to help manage diff panes (mostly to turn off diff once one diff window is closed). I use it a lot now and love it.

I do far less merging, so I just use basic three-way vimdiff. I launch vim with options to make it fullscreen, at the first conflict, and with windows ordered LOCAL, RESULT, REMOTE with [this git mergetool](https://github.com/idbrii/daveconfig/blob/master/multi/git/tool/mergetool.gvim.git.sh) (see [config](https://github.com/idbrii/daveconfig/blob/master/multi/git/.gitconfig#L67-L68) and it depends on [diffusable mappings](https://github.com/idbrii/vim-diffusable/blob/master/after/plugin/diffusable.vim#L19-L21) that are similar to unimpaired):

    gvim --nofork +"set lines=999" +"set columns=9999" +"wincmd =" +"wincmd w" +"normal gg]C" -d "$theirs" "$MERGED" "$mine"

I found splice.vim, but never got into it and feared the advertised incompatibility with vim-fugitive. Also, using a whole new set of maps for an infrequent operation doesn't sound fun. At some point I needed to do a lot of diffs and worked out this configuration that built on existing vim skills.

I can see some allure of using a plugin to automatically switch between window layouts since I often close one pane and re-open it. However, it's not too hard to revive the closed buffer with `:Unite buffer` (there are only three options) and that command re-uses existing functionality instead of creating a special case.

Also, by mostly relying on two pane diff I re-use the same diff key commands that I'm used to (and two-pane is easier for me to understand).

([ref](https://www.reddit.com/r/vim/comments/3fs0q9/is_there_an_active_fork_of_splicevim/ctsovn7))


Similarly, I use vim as a [perforce mergetool](https://github.com/idbrii/daveconfig/blob/master/win/system/bin/vimmerge.cmd).

([ref](https://www.reddit.com/r/vim/comments/32qtjb/vim_as_perforce_merge_tool/))



Writing Plugins or Packages
===========================
Don't remap trivial vanilla maps (like `gt` or `<C-w> v`). Encourage users to use existing commands so they learn the consistency built into vim.


Slowness
========
If vim is slow, then check `:helpgrep slow` and see if any of the results are relevant to you.

For me, folding was slowing me down and I used the [FastFold plugin](https://github.com/Konfekt/FastFold) to fix it. [ref](http://www.reddit.com/r/vim/comments/2ln1hr/my_vim_was_slow_because_of_foldmethodsyntax_and/)

Another common cause is syntax highlighting.

[LargeFile](https://github.com/idbrii/LargeFile) can help with loading enormous files by turning off some slow functionality.


Startup Performance
===================

If your vim is slow to start, use `--startuptime` to determine what is taking the most time. Focus on the amount of time to source a specific file (your vimrc may take a long time because it invokes other expensive scripts so you want to solve those scripts).

Most of the time, slowdown is because the of the quantity of code vim needs to process, but it can also be due to bad algorithms. When you find what's slow, there are three main ways to reduce the amount of code sourced in order of increasing benefits:

* Use ftplugin to only source code when editing filetypes that might use it.
* Use autoload to only source code at the moment of invocation.
* Don't source the code at all.

The last one is tricky, but "do less work" is the most universal optimization technique. You either need to accept the loss of functionality or find an alternative solution. For example, [FastFold disables automatic fold updating](http://www.reddit.com/r/vim/comments/2ln1hr/my_vim_was_slow_because_of_foldmethodsyntax_and/), but the speed boost is worth it. [vim-easy-align](https://github.com/junegunn/vim-easy-align) is an alternative to [tabular](https://github.com/godlygeek/tabular) that doens't have the high startup cost.


Reducing Colorscheme Startup Time
=================================

Another example of "do less work" is to make dynamic colorschemes static. Some colorschemes (like [Tomorrow](https://github.com/ChrisKempson/Vim-Tomorrow-Theme)) procedurally generate their `:highlight` commands. This generation can be time consuming and, when you have the same settings on every boot, pointless.

You could rewrite these dynamic colorschemes to output a static colorscheme instead of building it on startup. (I'm assuming a static scheme like desert loads much faster -- I assume it does since I only use static themes and I don't remember looking at colorscheme startup time.)

You need to find the function that builds the `:highlight` (often just `:hi`) command and calls `:exec`. Change that function (`<SID>X` in Tomorrow) to echo instead of exec, capture those values (`:redir`), and write them to a new colorscheme (a .vim file in ~/.vim/colors). Then use that colorscheme that file instead of your dynamic colorscheme. It won't be able to adapt to different conditions, but you could invoke that a static one for your most common use case and fall back to the original dynamic one in other cases.

[ref](http://www.reddit.com/r/vim/comments/38xjn3/my_first_plugin_vimdeferred_let_me_know_what_you/cs0ynfo?context=3)


Bugs
====
[Windows: Vim changing file permissions to 755 - Not any more!](http://www.reddit.com/r/vim/comments/2c6656/windows_vim_changing_file_permissions_to_755_not/)

