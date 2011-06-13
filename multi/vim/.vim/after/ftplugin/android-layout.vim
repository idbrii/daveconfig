" Use :make to check a layout

" An example layoutopt output looks like this:
"res/layout/crap2.xml
"[Fatal Error] :39:1: XML document structures must start and end within the same entity.
"
"	-1:-1 The layout could not be analyzed. Check if you specified a valid XML layout, if the specified file exists, etc.
"res/layout/crap.xml
"	12:32 Use an android:layout_width of 0dip instead of wrap_content for better performance


" Set the error format. Output is on multiple lines, so we use %P to push the
" filename onto the stack and %Q to pop it off. There are two kinds of errors
" I've seen: regular ones (begin with \t) and fatal ones.
"
" efm=Read the filename
"   ,regular errors
"   ,fatal errors
"   ,forget the filename
setlocal efm=%-P%f
    \,\	%l:%*[0-9]\ %m
    \,[Fatal\ %trror]\ :%l:%*[0-9]:\ %m
    \,%-Q


" For some reason, we can't set layoutopt as the makeprg -- it never outputs
" anything when run from vim, but it works fine from a terminal or from vim's
" :!
setlocal makeprg=make\ layoutopt
" Use a makefile like this:
"
"LAYOUTOPT = $(HOME)/data/code/android/android-sdk-linux_86/tools/layoutopt
"LAYOUTS = res/layout/*.xml
"
"layoutopt:	$(LAYOUTS)
"	$(LAYOUTOPT) $(LAYOUTS)
".PHONY: layoutopt
