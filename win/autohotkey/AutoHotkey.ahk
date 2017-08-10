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
; Source: https://stackoverflow.com/a/982954/79125
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

DoesMonitorHaveTaskbar(monitor_index) {
    ;; The left-most has the taskbar
    return monitor_index = 0
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

GetDesktopLeft(use_leftmost_monitor := false) {
    if (use_leftmost_monitor) {
        ActiveMonitor := 0
    } else {
        ActiveMonitor := GetActiveMonitorIndex()
    }
    SysGet, work_area_, MonitorWorkArea, ActiveMonitor
    ActiveMonitor := Convert_LeftToRightMonitorIndex(ActiveMonitor)

    ;; Skip past screens with the *full* width of a screen (not work_area_Right)
    offset_x := A_ScreenWidth * ActiveMonitor

    if (DoesMonitorHaveTaskbar(ActiveMonitor)) {
        offset_x += work_area_Left
    }
    return offset_x
}

;; TODO: Figure out how to reliably position things inside the current monitor.
;~ GetDesktopLeft(use_leftmost_monitor := false) {
;~   ;ActiveMonitor := GetActiveMonitorIndex()
;~   ;SysGet, workArea, MonitorWorkArea, ActiveMonitor

;~   if (use_leftmost_monitor) {
;~       ActiveMonitor := 0
;~   } else {
;~       ActiveMonitor := Convert_LeftToRightMonitorIndex(GetActiveMonitorIndex())
;~   }
;~   offset_x := A_ScreenWidth * ActiveMonitor

;~   WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
;~   TaskbarEdge := GetTaskbarEdge()

;~   if (DoesMonitorHaveTaskbar(ActiveMonitor) && TaskbarEdge = "left") {
;~     return TW + offset_x
;~   } else {
;~     return 0 + offset_x
;~   }
;~ }

GetDesktopWidth(use_leftmost_monitor := false) {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (use_leftmost_monitor) {
      ActiveMonitor := 0
  } else {
      ActiveMonitor := Convert_LeftToRightMonitorIndex(GetActiveMonitorIndex())
  }

  if (DoesMonitorHaveTaskbar(ActiveMonitor) && (TaskbarEdge = "left" or TaskbarEdge = "right")) {
    return A_ScreenWidth - TW
  } else {
    return A_ScreenWidth
  }
}

GetDesktopHeight(use_leftmost_monitor := false) {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (use_leftmost_monitor) {
      ActiveMonitor := 0
  } else {
      ActiveMonitor := Convert_LeftToRightMonitorIndex(GetActiveMonitorIndex())
  }

  if (DoesMonitorHaveTaskbar(ActiveMonitor) && (TaskbarEdge = "top" or TaskbarEdge = "bottom")) {
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
        if (monAreaLeft < winMidX && winMidX < monAreaRight && monAreaBottom > winMidY && winMidY > monAreaTop)
            ;; Monitor indexes start at 0 but loop indexes start at 1.
            return A_Index - 1
    }
    SysGet, primaryMonitor, MonitorPrimary
    return "No Monitor Found"
}

; Get the index of the monitor containing the specified x and y co-ordinates.
GetMonitorAt(x, y, default=1)
{
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m%
    {   ; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
            return A_Index
    }

    return default
}

GetMonitorIndexFromWindow(windowHandle)
{
    ;; Source: //autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355

	; Starts with 1.
	monitorIndex := 1

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)

	if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
		&& DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo)
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}

	return monitorIndex
}

#f11::
    monitor_index_GetActiveMonitorIndex := GetActiveMonitorIndex()

    WinGetPos, winX, winY, winWidth, winHeight, A
    winMidX := winX + winWidth / 2
    winMidY := winY + winHeight / 2
    monitor_index_GetMonitorAt := GetMonitorAt(winMidX, winMidY)

    WinGet, active_handle
    monitor_index_GetMonitorIndexFromWindow := GetMonitorIndexFromWindow(WinExist("A"))

    SysGet, workArea0_, MonitorWorkArea, 0
    SysGet, workArea1_, MonitorWorkArea, 1
    SysGet, workArea2_, MonitorWorkArea, 2

    listvars
return

;; Golden ratio window movement
;; Source: https://autohotkey.com/board/topic/85457-detecting-the-screen-the-current-window-is-on/

;-=---------------------------------------------------=-;
; Win Ctrl Left         golden ratio window resize left ;
;-=---------------------------------------------------=-;

golden_ratio := 1.61803398875
small_golden := 1/golden_ratio
big_golden := 1 - small_golden

Convert_LeftToRightMonitorIndex(ActiveMonitor) {
    ;; Leftmost monitor is 0.

    ;; Use 0-indexed for calculations
    ;~ ActiveMonitor := ActiveMonitor - 1

    ;; Hack: My monitors are laid out: 2 1
    SysGet, monitorCount, MonitorCount
    ActiveMonitor := monitorCount - ActiveMonitor - 1

    return ActiveMonitor
}

^#Left::
  WinRestore, A
  ActiveMonitor := GetActiveMonitorIndex()
  SysGet, workArea, MonitorWorkArea, ActiveMonitor
  workAreaWidth := workAreaRight - workAreaLeft
  workAreaHeight := workAreaBottom - workAreaTop

  ActiveMonitor := Convert_LeftToRightMonitorIndex(ActiveMonitor)
  monitorOffsetX := ActiveMonitor * workAreaWidth
  X := GetDesktopLeft()
  Y := GetDesktopTop()
  WinGetPos, winX, winY, winWidth, winHeight, A
  if (winX=workAreaLeft && winY=workAreaTop && winWidth=Floor(workAreaWidth*big_golden))
    WinMove, A, , X,Y, workAreaWidth * small_golden, %workAreaHeight%
  else
    WinMove, A, , X,Y, workAreaWidth * big_golden, %workAreaHeight%
return

;-=---------------------------------------------------=-;
; Win Ctrl Right       golden ratio window resize right ;
;-=---------------------------------------------------=-;

^#Right::
  WinRestore, A
  ActiveMonitor := GetActiveMonitorIndex()
  SysGet, workArea, MonitorWorkArea, ActiveMonitor
  workAreaWidth := workAreaRight - workAreaLeft
  workAreaHeight := workAreaBottom - workAreaTop
  WinGetPos, winX, winY, winWidth, winHeight, A
  X := GetDesktopLeft()
  Y := GetDesktopTop()
  if (winX=workAreaLeft+Floor(workAreaWidth * small_golden) && winY=workAreaTop && winWidth=Floor(workAreaWidth*big_golden))
    WinMove, A, , X + workAreaWidth * big_golden, Y, workAreaWidth * small_golden, workAreaHeight
  else
    WinMove, A, , X + workAreaWidth * small_golden, Y, workAreaWidth * big_golden, workAreaHeight
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

  ;; TODO: Use GetDesktopLeft(false)? Autodetect active window and position on
  ;; its monitor?
  LeftBound := GetDesktopLeft(true)
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

  LeftBound := GetDesktopLeft(true)
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

  LeftBound := GetDesktopLeft(true)
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

OrganizeDesktop()
{
    ;; Lay out windows for my three monitors with centre as the work machine.
    ;; Roughly in order of left-to-right appearance.
    WinMove,ahk_exe slack.exe,, 62, 0, 1140, 1080
    WinMove,ahk_class Vim,, 1913, -364, 1294, 1447
    ;; Game and log go here (but they position themselves).
    WinMove,ahk_exe chrome.exe,, 4480, 0, 974, 1080
    WinMove,ahk_exe bash.exe,, 5433, 0, 974, 1087

    SetTitleMatchMode 2 ;; A window's title can contain WinTitle anywhere inside it to be a match
    ;; Tortoise has lots of windows and they all have the same ahk_exe
    ;; (TortoiseProc.exe) and ahk_class (#32770). We could do try to match on
    ;; text inside the window, but the title should be pretty consistent so use
    ;; that instead.
    WinMove,Working Copy - TortoiseSVN,, 5433, 482, 974, 605
    SetTitleMatchMode 1 ;; Reset to default: A window's title must start with the specified WinTitle to be a match

}
#f12::
    OrganizeDesktop()
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


;; Why can't I add new maps here?

; Remap capslock?
; +CapsLock::CapsLock
; CapsLock::Escape


; vim:set et sts=-1 sw=2 ts=2 fdm=marker

