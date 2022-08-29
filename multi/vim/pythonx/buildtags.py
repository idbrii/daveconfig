#! /usr/bin/env python3

import os
os.environ['PATH'] = os.path.expanduser('~/scoop/apps/git/current/usr/bin/') + ';' + os.environ['PATH']

from pathlib import Path
import argparse
import os
import plumbum
import re
import tempfile

from plumbum.cmd import sed, grep, lua, ctags

# Installing dependents:
#   aptinstall universal-ctags cscope inotify-tools fswatch
#    -- fswatch requires universe (although it wasn't working for me under WSL)
#   scoop install universal-ctags
#   pip install pycscope fswatch
#   brew install fswatch


def _find(search_dirs, globs, additional_files):
    # TODO: Filter out .svn, etc.
    results = [p.glob("**/" + g) for p in search_dirs for g in globs]
    results = [p.as_posix() for r in results for p in r]
    if additional_files:
        results += [p.as_posix() for p in additional_files]
    return sorted(results, key=str.casefold)


def _find_and_writefile(output_fpath, search_dirs, globs, additional_files=None):
    results = _find(search_dirs, globs, additional_files)
    with output_fpath.open("w") as f:
        for line in results:
            f.write(line)
            f.write("\n")
    return results


def _get_and_validate_args():
    arg_parser = argparse.ArgumentParser(
        description="""Build the filelist, tag file, and cscope databases.

example to build C++ in current directory recursively:
  buildtags.sh --continous cscope cpp
example for the same but only tags (no filelist or cscope):
  buildtags.sh --skip-filelist --skip-cscope cpp
example for the same but no cscope:
  buildtags.sh --skip-cscope cpp""",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    arg_parser.add_argument(
        "--continuous", action="store_true", help="Keep trying to build."
    )

    arg_parser.add_argument(
        "--project-dir",
        default=Path.cwd(),
        help="Skip generating filelist.",
    )

    arg_parser.add_argument(
        "--skip-filelist",
        action="store_true",
        help="Skip generating filelist.",
    )

    arg_parser.add_argument(
        "--skip-cscope",
        action="store_true",
        help="Skip generating cscope.",
    )

    arg_parser.add_argument(
        "--cscope-binary",
        dest='cscope',
        default="cscope",
        help="The cscope executable to use. Default: cscope",
    )

    arg_parser.add_argument("filetype", help="The programming language to build for.")

    arg_parser.add_argument(
        "directories", nargs="*", help="The directories to search for code files."
    )

    args = arg_parser.parse_args()
    return args


def build_continuous(args):
    from fswatch import Monitor

    monitor = Monitor()
    for p in args.search_dirs:
        monitor.add_path(p)

    def callback(path, evt_time, flags, flags_num, event_num):
        print(path.decode())
        # Ignore vim swap file changes
        if re.search(r"/\..*\.sw?", path):
            print(f"Ignoring change to file {path}")
        else:
            print("Rebuild tags...")
            build(**args)

    monitor.set_callback(callback)
    monitor.start()


def build(
    project_dir, filetype, cscope, directories, skip_filelist=False, skip_cscope=False
):
    project_dir = Path(project_dir)
    if directories:
        search_dirs = [Path(p) for p in directories]
    else:
        search_dirs = [project_dir]
    tagdir = project_dir
    filelist = tagdir / "filelist"
    tags_file = tagdir / "tags"

    # debugging info
    # ~ print(f'cscope={cscope} filetype={filetype} filelist={filelist}')
    # ~ print(f'search_dirs={search_dirs}')

    os.chdir(tagdir)

    # Build filelist	{{{1
    filelist.unlink(missing_ok=True)

    if filetype == "cpp":
        # Probably a big c++ project, so use the simple format
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.cpp", "*.h", "*.inl"],
        )

    elif filetype == "lua-engine":
        # Lua-based engines use C++ and lua.
        _find_and_writefile(
            filelist,
            search_dirs,
            # r'-type d -name examples -prune -',
            ["*.cpp", "*.h", "*.inl", "*.lua", "*.glsl", "README.md"],
            project_dir.glob("*.lua"),
        )

    elif filetype == "unreal":
        # A big unreal c++ project, so use the simple format. Ignore generated code
        # in the Intermediate folder (a nuisance in plugins that don't have a fixed
        # path format).
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.cpp", "*.h", "*.inl"],
            # 'grep -v "Intermediate.Build"',
        )

    elif filetype == "cs":
        # C sharp code. don't include examples which are often alongside.
        _find_and_writefile(
            filelist,
            search_dirs,
            # r'-not \( -name "examples" -prune \) -a -not \( -name "obj" -prune \) -a'
            ["*.cs", "*.xaml"],
        )
        # Should try this:
        # _find_and_writefile(filelist,search_dirs, r'\( -type d -name "examples" -o -name "obj" \) -prune -o \( -type f -iname "*.cs", "*.xaml"), filelist)

    elif filetype == "android":
        # Android uses java and xml. Assume we're in the source directory
        dirs = search_dirs + [tagdir.parent / "res"]
        _find_and_writefile(
            filelist,
            dirs,
            ["*.xml", "*.java"],
        )

    elif filetype == "java":
        # The only types we're interested in are java
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.java"],
        )

    elif filetype == "rust":
        # Rust code.
        if "src" in search_dirs:
            # Usually keep code in src and want to access the cargo and any
            # documentation.
            search_dirs = [tagdir / f for f in "src ./Cargo.toml ./*.md".split(" ")]
            print("Using common rust config.")
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.rs", "*.toml", "*.md"],
        )

    elif filetype == "godot":
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.gd", "*.md", "*.tscn"],
        )

    elif filetype == "python":
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.py", "*.md"],
        )

    else:
        # Don't know what we are so include anything that's not binary or junk (from vimdoc)
        # DavidAdd: Files: .git tags filelist
        # DavidAdd: Filetypes: pyc out
        # DavidAdd: Folder: v (for virtualenv)
        # Trying to create globs to ignore seems crazy:
        # ["**/*.pyc", "**/*.jar", "**/*.gif", "**/*.jpg", "**/*.class", "**/*.exe", "**/*.dll", "**/*.pdd", "**/*.swp", "**/*.swo", "**/*.xls", "**/*.doc", "**/*.pdf", "**/*.zip", "**/*.tar", "**/*.ico", "**/*.ear", "**/*.war", "**/*.dat", "**/*.out",
        # "**/.git/**", "**/v/**", "**/.svn/**", "**/.bzr/**", "**/tags", "**/filelist"],
        # TODO: instead, we need to change our find to use os.walk.
        _find_and_writefile(
            filelist,
            search_dirs,
            ["*.*"],
        )

    # fd, name = tempfile.mkstemp(prefix="buildtags", text=True)
    # TMPFILE = open(fd, 'w')

    # convert cygwin paths to windows paths
    lines = sed("-e", r"s,^/cygdrive/\([[:alpha:]]\)/,\1:/,", filelist)
    with filelist.open("w") as f:
        f.write(lines)
    # I used to make a link in the root to each drive letter (/c for c:). With Bash
    # on Windows, I can just make a c:/mnt folder with all of the drives in it.
    # However, this acts wonky if the local drive isn't c:.
    # I'm not doing this here because Bash on Windows tools (ctags) need unix
    # paths. Instead, postponed this later so vim only sees Windows paths.
    # sed -i -e"s,^//\([[:alpha:]]\)/,\1:/," filelist
    # }}}

    # Build ctags and cscope	{{{1
    # Fixup the filelist

    operatingsystem = os.environ.get("OSTYPE", "")
    if "cygwin" in operatingsystem:
        # mlcscope needs full paths, so replace the relative path with the fully
        # qualified path
        # TODO: cygwin replaced mlcscope with cscope. Does it still have this problem?
        sed("--in-place", "-e", r"s|^\./|$tagdir/|", filelist)

    def fix_file_prefix_for_tags_on_win32(fpath):
        # Vim doesn't understand / as beginning of the path in Windows so it thinks
        # they're relative paths and can't find anything. (I'm using gvim.exe but
        # building tags with Unix subsystem.)
        sed("--in-place", "-e", r"s,/mnt/\([[:alpha:]]\)/,\1:/,", fpath)

        # For reference, opposite transformation.
        # sed -e"s,\([[:alpha:]]\):/,/mnt/\1/,"

    if filetype in ["cpp", "c"]:
        ctags("--c++-kinds=+p", "--fields=+iaS", "--extras=+q", "-L", filelist)
    elif filetype in ["cs"]:
        # Need namespace kind for inclement.
        # Need fields for tag completion.
        #
        # Using all kinds except:
        #   e  enumerators (enumeration values) -- just jump to enum instead
        #   f  fields -- adds 70% more bytes
        #   l  local variables -- adds 90% more bytes
        #
        # Using minimal field info:
        #   k Kind of tag as a single letter [enabled]
        #   s Scope of tag definition
        #   t Type and name of a variable or typedef as "typeref:" field
        # (excludes f from defaults because it didn't seem useful)
        #
        # Other fields:
        #   a Access (or export) of class members
        #   f File-restricted scoping
        #   i Inheritance information
        #   K Kind of tag as full name
        #   l Language of source file containing tag
        #   m Implementation information
        #   n Line number of tag definition
        #   S Signature of routine (e.g. prototype or parameter list)
        #   z Include the "kind:" key in kind field
        #
        # Trying out removing extras because it increases size by 1.2x.
        #
        # .\ctags.exe --extras=+fq --fields=+ianmzS --c#-kinds=cimnp
        #
        ctags("--c#-kinds=cismpdngtEf", "--fields=kst", "-L", filelist)

    elif filetype in ["lua-engine"]:
        # ltags makes for better lua tags and doesn't bloat the database with
        # c++.
        # Builds separate lua.tags from cpp tags file. Vim must have:
        #   setlocal tags+=./lua.tags;/
        # (See ~/.vim/bundle/lua-david/after/ftplugin/lua.vim)
        with filelist.open('r') as f:
            lines = [line for line in f if "lua" in line]
        luafiles = tagdir / "filelist.luaonly"
        with luafiles.open('w') as f:
            for line in lines:
                f.write(line)
        # The -nv option is no good for us since we declare classes as locals
        # returned from a file. Don't use it!
        # However my -nr option works with our way of declaring classes.
        ltags = os.path.expanduser("~/.vim/bundle/lua-david/lib/ltags/ltags")
        lua(ltags, "-nr", "-filelist", luafiles)
        luafiles.unlink()

        luatags = tagdir / "lua.tags"
        luatags.unlink(missing_ok=True)

        fix_file_prefix_for_tags_on_win32(tags_file)
        tags_file.rename(luatags)

        ctags(
            "--c++-kinds=+p",
            "--fields=+iaS",
            "--extras=+q",
            "-L",
            filelist,
            "--exclude=*.lua",
        )

    else:
        ctags("-L", filelist)

    fix_file_prefix_for_tags_on_win32(tags_file)

    if skip_filelist:
        filelist.unlink()

    elif skip_cscope:
        # Make empty cscope files so scripts expecting them don't barf.
        for mid in ["in.", "po.", ""]:
            p = tagdir / ("cscope." + mid + "out")
            p.touch()

    elif filetype == "python":
        # Requires the python package pycscope:
        #   pip install pycscope
        import pycscope
        pycscope.main(["-i", filelist.as_posix()])
        # pycscope = plumbum.local["pycscope"]
        # pycscope("-i", filelist)
    else:
        # Build cscope database
        # 	-b              Build the database only.
        # 	-k              Kernel Mode - don't use /usr/include for #include files.
        # 	-q              Build an inverted index for quick symbol seaching.
        # May want to consider these flags
        # 	-m "lang"       Use lang for multi-lingual cscope.
        # 	-R              Recurse directories for files.
        cscope = plumbum.local[cscope]
        cscope("-b", "-q", "-k", "-i", filelist)

        # While cscope changed from cscope.out.$type to cscope.$type.out [1],
        # mlcscope will still complain that it cannot find cscope.out.in. Ignore
        # this error! It's not failing to find cscope.in.out, it's just stupid. If
        # you try to rename the files (mv cscope.in.out cscope.out.in), cscope will
        # stop working (you'll get errors about your database being invalid).
        # [1] https://bugzilla.redhat.com/show_bug.cgi?format=multiple&id=602738
        # TODO: cygwin replaced mlcscope with cscope. Does it still have this problem?

    # }}}

    fix_file_prefix_for_tags_on_win32(filelist)


if __name__ == "__main__":
    args = _get_and_validate_args()
    continuous_build = args.continuous
    args_dict = args.__dict__
    del args_dict["continuous"]
    build(**args_dict)
    if continuous_build:
        build_continuous(args)
