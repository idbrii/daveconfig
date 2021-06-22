:: Sandbox build file.
::
:: Use this in vim to use it to build
::		setlocal makeprg=c:/sandbox/build_cs.bat\ %
:: Uses Microsoft's compiler.
@call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 >NUL
:: csc.exe /?

:: @echo We're ignoring some warnings because they occur in Microsoft code.
:: @set no_warn=/nowarn:E222
@echo on
csc.exe /nologo /D:DEBUG /out:out.exe /warn:4 %no_warn% %*
@echo off

if %ERRORLEVEL% == 0 (
	echo Executing out.exe...
	out.exe
)
