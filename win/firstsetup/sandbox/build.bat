:: Sandbox build file.
::
:: Use this in vim to use it to build
::		setlocal makeprg=c:/sandbox/build.bat\ %
:: Uses Microsoft's compiler.
@call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 >NUL

@echo We're ignoring some warnings because they occur in Microsoft code.
:: xstring|689 warning 4350| behavior change: 'std::_Wrap_alloc<_Alloc>::_Wrap_alloc(const std::_Wrap_alloc<_Alloc> &) throw()' called instead of 'std::_Wrap_alloc<_Alloc>::_Wrap_alloc<std::_Wrap_alloc<_Alloc>>(_Other &) throw()'
@echo on
cl.exe /nologo /Wall /wd4820 /wd4530 /wd4514 /wd4986 /wd4350 /Feout.exe %*
@echo off

if %ERRORLEVEL% == 0 (
	echo Executing out.exe...
	out.exe
)
