" vim: ai et ts=4 sw=4 tw=78:
"    Python_Calltips 1.01 
"    (C) Copyright 2004 by tocer deng   MAIL: tocer.deng@gmail.com
"
"    This script simulates code call tips in a new bottom window of Vim.
"    In fact, it displays Python help doc strings of word under the cursor
"    by scanning the imported modules and functions in the current file.
"
"    It requires Python and Vim compiled with "+python",
"    and MAKE SURE "set iskeyword+=."
"    
"    It works well in my box in Win2000 + Vim6.3 + python2.3. 
"    It can also work in GNU/Linux.
"    If it can work in other platform or other versions of Vim, let me know.
"    Note: As I know, Vim 6.2 comes into conflict with Python 2.3, because Vim 6.2
"          is compiled with Python 2.1. You can update Vim to version 6.3.
"          Maybe yours not.
"          
"    Install:
"           Put the plugin into "$VIMRUNTIME/ftplugin" folder.
"           
"    Usage: 
"        1. If there is a menu in Vim, you can start it with clicking menu 
"           "Tools\Start Calltips", and stop it with menu "Tools\End Calltips"
"
"        2. If there are no menu, you can start it typing:
"             :call DoCalltips()
"           and stop it with
"             :call EndCalltips()
"
"        3. The plugin also implements word automatic complete. I think it is
"           better than pyDiction plugin. When call tips are displayed in call tips window,
"           you can press keys: <Alt-1> ... <Alt-5> to select the call tip you want.  
"           If you don't understand yet, try it yourself.
"           
"    THANKS:
"        montumba, Guilherme Salgado, Staale Flock, Levin Du
"
"    English is not my native language, so there may be many mistakes of expression.
"    If you have any question, feel free to mail to write2tocer@hotmail.com
"    If you enjoy it, mail me too, I'm happy to share your joy.

if exists("g:loaded_python_calltips") && g:loaded_python_calltips==1
  finish
endif
let g:loaded_python_calltips = 1
let s:MenuBuilt = 0

"If you don't want to auto start calltips while first loaded, let s:FirstStart=0 
let s:FirstStart = 0

if ! has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

"Most code of five functions below is distributed by Staale Flock
"
func! <SID>SetEventHooks()
    "Use augroup to make sure the autocommand is not nested
    augroup PythonCallTips
        " Remove previous definitions for this group
        au!
        if &filetype == "python"
            au BufEnter * :call <SID>BuildMenu()
            au BufLeave * :call <SID>TearDownMenu()
        endif
    augroup END
endfunc
          
func! <SID>BuildMenu()
" Build menu when we enter filetype=python    
    if has("menu") && (s:MenuBuilt == 0) 
        if (&filetype == "python")
            amenu &Tools.&Start\ Calltips :call <SID>DoCalltips()<CR>
            amenu &Tools.&Stop\ Calltips :call <SID>EndCalltips()<CR>
            "echo "python_caltips BuildMenu"
            let s:MenuBuilt = 1
        endif
    endif    

    "Tocer: I found map keys aren't available once buffer leave and enter back,
    "       for support multi Python buffer in one window, add it.
    if (&filetype == "python") && (s:FirstStart == 1)
        execute "python CT_MapKeys()"
    endif
    let s:FirstStart = 1
endfunc

func! <SID>TearDownMenu()
" Teardown menu when we leave filetype=python
    if has("menu") && (s:MenuBuilt == 1) 
        if (&filetype == "python")
            aunmenu &Tools.&Start\ Calltips
            aunmenu &Tools.&Stop\ Calltips
            "echo "python_caltips TearDownMenu"
            let s:MenuBuilt = 0
        endif
    endif

    "Tocer: Clear unused Python variable.
    if (&filetype == "python")
        execute "python CT_DelUnusedObject()"
    endif
endfunc

func! <SID>DoCalltips()
    if bufwinnr("-Python_Calltips-") < 1
        execute "python CT_CreateTipsWin()"            
    endif
    execute "python CT_MapKeys()"         
endfunc

func! <SID>EndCalltips()
    "To Staale: your below code can't work well, and I don't know
    "           how to do yet :(
    "Stalle:
    "We should traverse each python buffer and clear stuff
    "Moved from below and added loop. Maybe it would be better to
    "maintain a list of buffers where we have done a CT_mapkeys?
    "let nBuffers = bufnr("$")
    "let i = 0
    "while i<= nBuffers
    "    let i = i + 1
    "    if &filetype == "python"
    "       "execute "python CT_UnMapKeys()"
    "    endif
    "endwhile

    "FIXME: disalbe all python buffer mapkeys while user end calltips
    execute "python CT_UnMapKeys()"
    execute "python CT_CloseTipsWin()"            
    execute "python CT_DelUnusedObject()"         
endfunc
    
"======================================================================
" System definition
"======================================================================
function! <SID>DefPython()
python << PYTHONEOF
import vim
import __builtin__
from string import letters
try:
    from sets import Set
except:
    pass

def CT_AutoCompleteWord(index):
    """Return matched word in calltip window"""
    try:
        #get first field of index line of tips_buffer
        if tips_buffer[index-1].find('__builtin__') == 0:  #see if builtin function
            autoPart = tips_buffer[index-1].split()[0][len(CT_GetWordUnderCursor())+12:]  #11: len('__biultin__.')
        else:
            autoPart = tips_buffer[index-1].split()[0][len(CT_GetWordUnderCursor()):]
        vim.command('execute "normal a' + autoPart + '"')
    except:
        #print "auto complete ERROR"
        pass
    vim.command('startinsert!')   #from normal mode into insert mode
    #print autoPart

def CT_DspTips():
    """Display help doc string in Python calltips buffer"""
    if not CT_ExistTipsWin():
        CT_CreateTipsWin()
    tips_buffer[:] = None
    docs = CT_GetHelpDoc(CT_GetWordUnderCursor())

    #print docs
    for line in docs:
        tips_buffer.append(line)
    del tips_buffer[0]

    #from normal mode into insert mode
    y, x = vim.current.window.cursor
    if len(vim.current.line) > x + 1:
        vim.command('normal l')
        vim.command('startinsert')
    else:
        vim.command('startinsert!')

def CT_GetHelpDoc(word):   
    """Return module or methods's  doc strings."""
    
    helpDoc = []
    spacing=16
    if len(word.split('.')) == 1:      #see if type "xxx."
        s = '__builtin__'
        m = word
    else:
        rindex= word.rfind('.')        #see if type "xxx.xx"
        s = word[:rindex]
        y, x = vim.current.window.cursor
        m = word[rindex+1:x+1]
    try:
        object = eval(s)
    except:
        return []
    joinLineFunc = lambda s: " ".join(s.split())

    methodList = [method for method in dir(object) \
                         if method.find('__') != 0 and \
                            method.find(m) == 0    and \
                            '__doc__' in dir(getattr(object, method))]
    helpDoc.extend(["%s.%s %s" %
                    (s,method.ljust(spacing),
                     joinLineFunc(str(getattr(object, method).__doc__)))
                     for method in methodList])
    return helpDoc

def CT_GetWordUnderCursor():
    """ Returns word under the current buffer's cursor."""
    stack = []
    leftword = rightword = popword = word = ''
    WORD = vim.eval('expand("<cWORD>")')  #return a big WORD

    #According '.', seperate the WORD into left part and right part
    rindex = WORD.rfind('.')
    if rindex == -1:      #if a WORD is not include '.'
        leftWORD = ''
        rightWORD = WORD
    else:
        leftWORD = WORD[:rindex]        
        rightWORD = WORD[rindex+1:]
    #print "WORD=%s, leftWORD=%s rightWORD=%s" % (WORD, leftWORD, rightWORD)

    #analyzing left part of the WORD
    for char in leftWORD:
        if char in letters + '.':
            popword += char
            continue
        elif char == '(' or char == '[':
            stack.append(popword)
            popword = ''
            continue
        elif char == ')' or char == ']':
            leftword=stack.pop()
            popword = ''
            continue
        else:
            popword = ''
    if popword != '': leftword = popword  
    #print "leftword=%s" % leftword

    #analyzing right part of the WORD
    for char in rightWORD:
        if char not in letters:
            break
        rightword += char
    #print "rightword=%s" % rightword
    
    if leftword != '':
        word = "%s.%s" % (leftword, rightword)
    else:
        word = rightword
    #print word

    return word

def CT_ParseSyntax():
    """parse source code"""
    import tokenize
    import keyword
    import StringIO
    text='\n'.join(vim.current.buffer[:]) + '\n'
    f = StringIO.StringIO(text)
    g = tokenize.generate_tokens(f.readline)
    lineNo = 0
    try:
        for tokenType, t, start, end, line in g:
            if start[0] == lineNo: continue
            if tokenType == tokenize.INDENT or tokenType == tokenize.DEDENT \
                     or tokenize.tok_name[tokenType] == 'NL' \
                     or tokenType == tokenize.ERRORTOKEN \
                     or tokenType == tokenize.ENDMARKER \
                     or start[0] == lineNo: continue
            if t == 'import':
                module = ''
                while 1:
                    tokenType, t, start, end, line = g.next()
                    if t == ';' or tokenType == tokenize.NEWLINE:
                        try:
                            exec('import %s' % module) in globals()
                        except: pass
                            #print "Ignore: can't import %s.\t" % module
                        break
                    elif (tokenType == tokenize.OP and t == ','):
                        try:
                            exec('import %s' % module) in globals()
                        except: pass
                            #print "Ignore: can't import %s.\t" % module
                        module = ''
                        continue
                    module += t + ' '
            elif t == 'from':
                module = ''
                while 1:
                    tokenType, t, start, end, line = g.next()
                    if t == 'import': break
                    module += t
                function = ''
                while 1:
                    tokenType, t, start, end, line = g.next()
                    if  t == ',':
                        try:
                            exec('from %s import %s' % (module, function)) in globals()
                        except: pass
                            #print "Ignore: can't from %s import %s.\t" % (module, function)
                        function = ''
                        continue
                    elif tokenType == tokenize.NEWLINE:
                        try:
                            exec('from %s import %s' % (module, function)) in globals()
                        except: pass 
                            #print "Ignore: can't from %s import %s.\t" % (module, function)
                        break
                    function += t + ' '
            
            elif t == 'class':
                i = 0
                l = 'class '
                classBlock = []
                while 1:
                    tokenType, t, start, end, line = g.next()
                    if tokenType == tokenize.INDENT:
                        i += 1
                        l = ' '*i*4
                    elif tokenType == tokenize.DEDENT:
                        i -= 1
                        l = ' '*i*4
                        if i == 0: break
                    elif tokenType == tokenize.NEWLINE or\
                             tokenType == tokenize.NL      or\
                             tokenType == tokenize.COMMENT:
                        classBlock.append(l)
                        l = ' '*i*4
                    else:
                        l += t + ' '
                #print "class: %s" % classBlock[0]
                try:
                    exec('\n'.join(classBlock)+'\n') in globals()
                except: pass
                    #print "Ignore: can't import %s" % classBlock[0]
            elif keyword.iskeyword(t):
                lineNo = start[0]
            else:
                if t in globals():
                    lineNo = start[0]
                    continue
                varName = t
                tokenType, t, start, end, line = g.next()
                if t == '=':
                    tokenType, t, start, end, line = g.next()
                    if tokenType == tokenize.NEWLINE: break
                    elif t == 'tips_buffer': pass
                    #see if vars ='xxx' or "xxx" or '''xxx''' or """xxx""" or str(xxx)
                    elif tokenType == tokenize.STRING or t == 'str':  
                        #print 'sting:%s' % varName
                        exec('%s = CT_STRINGTYPE' % varName)  in globals()
                    #see if vars = [] or list()
                    elif t == '[' or t == 'list':
                        #print 'list:%s' % varName
                        exec('%s= CT_LISTTYPE' % varName)  in globals()
                    #see if vars = {} or dict()
                    elif t == '{' or t == 'dict':
                        #print 'dict:%s' % varName
                        exec('%s = CT_DICTTYPE' % varName)  in globals()
                    #see if vars = NUMBER
                    elif tokenType == tokenize.NUMBER:
                        pass
                        #print 'number:%s' % varName
                    #see if vars = Set([xxx])
                    elif t == 'Set': 
                        #print 'set:%s' % varName
                        try:
                            exec('%s = CT_SETTYPE' % varName)  in globals()
                        except:
                            pass
                    #see if vars = open(xxx) or file(xxx)
                    elif t == 'open' or t == 'file':
                        #print 'file:%s' % varName
                        exec('%s = CT_FILETYPE' % varName)  in globals()
                    else:
                        instance = t
                        #pywin.debugger.set_trace()
                        while 1:
                            tokenType, t, start, end, line = g.next()
                            if tokenType == tokenize.NAME and t == '.':
                                instance += t
                            elif tokenType == tokenize.NEWLINE: break
                            else:
                                #print 'instance: %s' % line
                                try:
                                    exec('%s = %s' % (varName, instance))  in globals()
                                except: pass
                                    #print 'ERROR: %s = %s' % (varName, instance)  
                                break
                lineNo = start[0]
    finally:
        return

def CT_MapKeys():
    """mapping keys"""
    #mapping "a-zA-Z" keys
    for letter in letters:    
        vim.command("inoremap <silent> <buffer> %s %s<Esc>:python CT_DspTips()<CR>" \
                    % (letter, letter))
    #mapping "." key
    vim.command("inoremap <silent> <buffer> . .<ESC>:python CT_ParseSyntax()<CR>:python CT_DspTips()<CR>")
    #mapping "Back Space" keys
    vim.command("inoremap <silent> <buffer> <BS> <BS><Esc>:python CT_DspTips()<CR>")
    #mapping "<Alt-1> ... <Alt-5>" key
    vim.command("inoremap <silent> <buffer> <M-1> <Esc>:python CT_AutoCompleteWord(1)<CR>")
    vim.command("inoremap <silent> <buffer> <M-2> <Esc>:python CT_AutoCompleteWord(2)<CR>")
    vim.command("inoremap <silent> <buffer> <M-3> <Esc>:python CT_AutoCompleteWord(3)<CR>")
    vim.command("inoremap <silent> <buffer> <M-4> <Esc>:python CT_AutoCompleteWord(4)<CR>")
    vim.command("inoremap <silent> <buffer> <M-5> <Esc>:python CT_AutoCompleteWord(5)<CR>")

def CT_UnMapKeys():
    """disable mapped keys"""
    try:
        #Unmapping "a-zA-Z." keys
        for letter in letters+'.':    
            vim.command('iunmap <buffer> %s' % letter)
        #Unmapping "Back Space" keys
        vim.command('iunmap <buffer> <BS>')
        #Unmapping "<Alt-1> ... <Alt-5>" key
        vim.command('iunmap <buffer> <M-1>')
        vim.command('iunmap <buffer> <M-2>')
        vim.command('iunmap <buffer> <M-3>')
        vim.command('iunmap <buffer> <M-4>')
        vim.command('iunmap <buffer> <M-5>')
    except:
        pass

def CT_CreateTipsWin():
    """create a calltips window"""
    if CT_ExistTipsWin(): return

    global tips_buffer
    source_buffer = vim.current.buffer.name
    vim.command('silent rightbelow 5new -Python_Calltips-')
    vim.command('set buftype=nofile')
    vim.command('set noswapfile')
    vim.command('set nonumber')
    vim.command('set nowrap')
    vim.command('syn match PCTKeyWord '+"'"+'^\w*\.\w*\ '+"'")
    vim.command('hi def link PCTKeyWord Special')
    tips_buffer = vim.current.buffer
    while True:
        vim.command('wincmd w')   #switch back window
        if source_buffer == vim.current.buffer.name:
            break

def CT_CloseTipsWin():
    """close calltips window"""
    vim.command('silent! bwipeout -Python_Calltips-')

def CT_DelUnusedObject():
    """delete unused python object"""

    ALL = ['CT_AutoCompleteWord','CT_CloseTipsWin','CT_CreateTipsWin',\
           'CT_DelUnusedObject','CT_DspTips','CT_ExistTipsWin',\
           'CT_GetWordUnderCursor','CT_GetHelpDoc', 'CT_MapKeys',\
           'CT_ParseSyntax', 'CT_UnMapKeys',\
           '__builtin__', '__builtins__', '__doc__', \
           '__name__', 'vim', 'letters', 'tips_buffer', 'CT_STRINGTYPE', \
           'CT_LISTTYPE', 'CT_DICTTYPE', 'CT_FILETYPE', 'CT_SETTYPE', 'Set']
          
    for object in globals().keys():
        if object not in ALL:
            try:
                exec('del %s' % object) in globals()
            except: pass
                #print 'Fail: del %s' % object

def CT_ExistTipsWin():
    for win in vim.windows:
        try:                 #FIXME: Error while new a unnamed buffer
            if 'Python_Calltips' in win.buffer.name:
                return True
        except: pass
    return False


CT_STRINGTYPE = str
CT_LISTTYPE   = list
CT_DICTTYPE   = dict
CT_FILETYPE   = file
CT_SETTYPE    = Set
from sys import path
path.extend(['.','..'])  #add current path and parent path
PYTHONEOF

endfunction

"====================================================================
"  Start
"====================================================================
call <SID>DefPython()
call <SID>SetEventHooks()
