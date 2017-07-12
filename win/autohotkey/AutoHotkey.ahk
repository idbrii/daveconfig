; Blurb {{{1
; Install: Just create a shortcut to this file in Startup

; !: Sends an ALT keystroke. Send This is text!a would send the keys "This is text" and then press ALT+a.
; +: Sends a SHIFT keystroke. Send +abC would send the text "AbC", and Send !+a would press ALT+SHIFT+a.
; ^: Sends a CONTROL keystroke. Send ^!a would press CTRL+ALT+a, and Send ^{Home} would send CONTROL+HOME.
; #: Sends a WIN keystroke, therefore Send #e would hold down the Windows key and then press the letter "e".


; Config begin {{{1

; Auto-replace the previous instance
#SingleInstance force

; Helper Functions {{{1

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

GetActiveMonitorIndex()
{
    ;; Which monitor is the active window on? Uses index understood by SysGet.
    ;; Source: https://autohotkey.com/board/topic/85457-detecting-the-screen-the-current-window-is-on/

    SysGet, numberOfMonitors, MonitorCount
    WinGetPos, winX, winY, winWidth, winHeight, A
    winMidX := winX + winWidth / 2
    winMidY := winY + winHeight / 2
    Loop %numberOfMonitors%
    {
        SysGet, monArea, Monitor, %A_Index%
        if (winMidX > monAreaLeft && winMidX < monAreaRight && winMidY < monAreaBottom && winMidY > monAreaTop)
            return A_Index
    }
    SysGet, primaryMonitor, MonitorPrimary
    return "No Monitor Found"
}

;; Movement in thirds.
;; Source: https://autohotkey.com/board/topic/85457-detecting-the-screen-the-current-window-is-on/

;-=---------------------------------------------------=-;
; Win Ctrl Left         golden ratio window resize left ;
;-=---------------------------------------------------=-;

golden_ratio := 1.61803398875
small_golden := 1/golden_ratio
big_golden := 1 - small_golden

^#Left::
  WinRestore, A
  SysGet, workArea, MonitorWorkArea, GetActiveMonitorIndex()
  workAreaWidth := workAreaRight - workAreaLeft
  workAreaHeight := workAreaBottom - workAreaTop
  WinGetPos, winX, winY, winWidth, winHeight, A
  if (winX=workAreaLeft && winY=workAreaTop && winWidth=Floor(workAreaWidth*big_golden))
    WinMove, A, , %workAreaLeft%, %workAreaTop%, workAreaWidth * small_golden, %workAreaHeight%
  else
    WinMove, A, , %workAreaLeft%, %workAreaTop%, workAreaWidth * big_golden, %workAreaHeight%
return

;-=---------------------------------------------------=-;
; Win Ctrl Right       golden ratio window resize right ;
;-=---------------------------------------------------=-;

^#Right::
  WinRestore, A
  SysGet, workArea, MonitorWorkArea, GetActiveMonitorIndex()
  workAreaWidth := workAreaRight - workAreaLeft
  workAreaHeight := workAreaBottom - workAreaTop
  WinGetPos, winX, winY, winWidth, winHeight, A
  if (winX=workAreaLeft+Floor(workAreaWidth * small_golden) && winY=workAreaTop && winWidth=Floor(workAreaWidth*big_golden))
    WinMove, A, , workAreaLeft + workAreaWidth * big_golden, workAreaTop, workAreaWidth * small_golden, workAreaHeight
  else
    WinMove, A, , workAreaLeft + workAreaWidth * small_golden, workAreaTop, workAreaWidth * big_golden, workAreaHeight
return


ResizeAndCenter(w, h)
{
  ScreenX := GetDesktopLeft()
  ScreenY := GetDesktopTop()
  ScreenWidth := GetDesktopWidth()
  ScreenHeight := GetDesktopHeight()

  WinMove A,,ScreenX + (ScreenWidth/2)-(w/2),ScreenY + (ScreenHeight/2)-(h/2),w,h
}

SlimOnLeftOfGame()
{
  UseRightScreen := True
  GameWidth := 1100
  FitToLeftOfWin(UseRightScreen, GameWidth)
}

SlimOnRightOfGame()
{
  UseRightScreen := False
  GameWidth := 1280
  FitToRightOfWin(UseRightScreen, GameWidth)
}

SlimBelowGame()
{
  UseRightScreen := False
  GameWidth := 1280
  GameHeight := 1280 / 16 * 9
  FitBelowWin(UseRightScreen, GameHeight, GameWidth)
}

FitToRightOfWin(UseRightScreen, AdjacentWidth)
{
; Put a window in the space next to my game.

  LeftBound := GetDesktopLeft()
  RightBound := A_ScreenWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := A_ScreenWidth * 2
  }
  ScreenX := LeftBound + AdjacentWidth
  ScreenY := GetDesktopTop()
  ScreenWidth := RightBound - AdjacentWidth - LeftBound
  ScreenHeight := GetDesktopHeight()

  WinMove A,,ScreenX,ScreenY,ScreenWidth,ScreenHeight
}

FitToLeftOfWin(UseRightScreen, AdjacentWidth)
{
; Put a window in the space next to my game.

  LeftBound := GetDesktopLeft()
  RightBound := A_ScreenWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := A_ScreenWidth * 2
  }
  ScreenX := LeftBound
  ScreenY := GetDesktopTop()
  ScreenWidth := RightBound - AdjacentWidth - LeftBound
  ScreenHeight := GetDesktopHeight()

  WinMove A,,ScreenX,ScreenY,ScreenWidth,ScreenHeight
}

FitBelowWin(UseRightScreen, AdjacentHeight, AdjacentWidth)
{
; Put a window in the space below to my game.

  LeftBound := GetDesktopLeft()
  RightBound := AdjacentWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := AdjacentWidth + A_ScreenWidth
  }
  ScreenX := LeftBound
  ScreenY := AdjacentHeight
  ScreenWidth := AdjacentWidth
  ScreenHeight := GetDesktopHeight() - AdjacentHeight

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

; Window Management {{{1

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

; Put window next to game
#|::
	SlimOnLeftOfGame()
return

; Put window under game
#_::
	SlimBelowGame()
return

; Program Shortcuts {{{1

#v::
	KeyWait LWin
	Run %vim_bin%\gvim.exe
return

; Misc {{{1

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

; Easy paste in terminal
; S-Ins requires Fn mode on my Kinesis. Use the gnome-terminal shortcut C-S-v
; instead.
; Disabled. Unnecessary when using Ctrl+Shift+letter shortcuts:
;	https://code.google.com/p/mintty/issues/detail?id=252
;#IfWinActive ahk_class mintty
;{
;	^+v::
;		Send {Shift down}{Insert}{Shift Up}
;	return
;}

; Easy paste in command prompt
; Might as well be consistent (and convenient).
#IfWinActive ahk_class ConsoleWindowClass
{
	^+v::
		SendInput {Raw}%clipboard%
	return
}

; Easy copy in command prompt
; More consistency.
#IfWinActive ahk_class ConsoleWindowClass
{
    ^+c::
    {
        if (WinActive("ahk_exe bash.exe")) {
            ; Bash prompt uses right click
            Click right
        }
        else {
            ; Alt-Space e y
            ; Opens the window menu > Edit > Copy
            Send !{Space}ey
        }
        return
    }
}



; Remap capslock?
; +CapsLock::CapsLock
; CapsLock::Escape


; vim:set et sts=-1 sw=2 ts=2 fdm=marker

