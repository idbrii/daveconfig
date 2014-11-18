; Install: Just create a shortcut to this file in Startup

; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.






; Auto-replace the previous instance
#SingleInstance force

; Helper Functions -------------------------------------------------------------

; Gets the edge that the taskbar is docked to.  Returns:
;   "top"
;   "right"
;   "bottom"
;   "left"
GetTaskbarEdge() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,

  if (TW = A_ScreenWidth) { ; Vertical Taskbar
    if (TY = 0) {
      return "top"
    } else {
      return "bottom"
    }
  } else { ; Horizontal Taskbar
    if (TX = 0) {
      return "left"
    } else {
      return "right"
    }
  }
}

GetDesktopTop() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top") {
    return TH
  } else {
    return 0
  }
}

GetDesktopLeft() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "left") {
    return TW
  } else {
    return 0
  }
}

GetDesktopWidth() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top" or TaskbarEdge = "bottom") {
    return A_ScreenWidth
  } else {
    return A_ScreenWidth - TW
  }
}

GetDesktopHeight() {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (TaskbarEdge = "top" or TaskbarEdge = "bottom") {
    return A_ScreenHeight - TH
  } else {
    return A_ScreenHeight
  }
}

ResizeAndCenter(w, h)
{
  ScreenX := GetDesktopLeft()
  ScreenY := GetDesktopTop()
  ScreenWidth := GetDesktopWidth()
  ScreenHeight := GetDesktopHeight()

  WinMove A,,ScreenX + (ScreenWidth/2)-(w/2),ScreenY + (ScreenHeight/2)-(h/2),w,h
}

SlimRight()
{
; Put a window in the space next to my game.
  UseRightScreen := False

  GameWidth := 1280

  LeftBound := GetDesktopLeft()
  RightBound := A_ScreenWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := A_ScreenWidth * 2
  }
  ScreenX := LeftBound + GameWidth
  ScreenY := GetDesktopTop()
  ScreenWidth := RightBound - GameWidth - LeftBound
  ScreenHeight := GetDesktopHeight()

  WinMove A,,ScreenX,ScreenY,ScreenWidth,ScreenHeight
}

ToggleMaximized()
{
   WinGet MX, MinMax, A
   if MX
		WinRestore A
   else
		WinMaximize A
}

; Window Management ------------------------------------------------------------

#a::WinSet AlwaysOnTop, Toggle, A,,,

;#1::
;  ResizeAndCenter(800,600)
;return

;#2::
;  ResizeAndCenter(1024,768)
;return

;#3::
;  ResizeAndCenter(1280,1024)
;return

;#-::
;  WinGetPos,,,W,H,A
;  WinMove a,,,,W-1,H-1
;  ;WinMove a,,,,W,H
;return

#0::
  ScreenWidth := GetDesktopWidth()
  ScreenHeight := GetDesktopHeight()
  ResizeAndCenter((ScreenWidth / 2), (ScreenHeight / 2))
return

; Move window to left edge of screen

#Numpad7::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  WinMove A,,SX,SY,,
return

#Numpad4::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX,SY + (SH/2) - (H/2),,
return

#Numpad1::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX,SY + SH - H,,
return

; Move window to center of screen

#Numpad8::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY,,
return

#Numpad5::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY + (SH/2)-(H/2),,
return

#Numpad2::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY + SH-H,,
return

; Move window to right edge of screen

#Numpad9::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  WinGetPos,,,W,H,A
  WinMove A,,SX + SW-W,SY,,
return

#Numpad6::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + SW-W,SY + (SH/2)-(H/2),,
return

#Numpad3::
  SX := GetDesktopLeft()
  SY := GetDesktopTop()
  SW := GetDesktopWidth()
  SH := GetDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + SW-W,SY + SH-H,,
return

; maximize the active window.
#x::
	ToggleMaximized()
return

; maximize the active window.
#|::
	SlimRight()
return

; Program Shortcuts ------------------------------------------------------------

#v::
	KeyWait LWin
	Run C:\david\apps\Vim\vim74\gvim.exe
return

; Misc -------------------------------------------------------------------------

;Close (alt+F4) with Win-q
#q::
	;KeyWait LWin
	WinGet A
	WinClose A
return

;Minimize with Win-z
#z::
	;KeyWait LWin
	WinGet A
	WinMinimize A
return

; Remap capslock?
; +CapsLock::CapsLock
; CapsLock::Escape

; vim:set et sts=-1 sw=2 ts=2
