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
    return monitor_index = Convert_LeftToRightToMonitorIndex(0)
}

GetCurrentDesktopTop() {
    return GetDesktopTop(Convert_MonitorIndexToLeftToRight(GetActiveMonitorIndex()))
}

GetDesktopTop(ActiveMonitor) {
    MonitorIndex := Convert_LeftToRightToMonitorIndex(ActiveMonitor)
    SysGet, work_area_, MonitorWorkArea, %MonitorIndex%
    return work_area_Top
}

GetCurrentDesktopLeft(use_leftmost_monitor := false) {
    if (use_leftmost_monitor) {
        ActiveMonitor := 0
    } else {
        ActiveMonitor := Convert_MonitorIndexToLeftToRight(GetActiveMonitorIndex())
    }
    return GetDesktopLeft(ActiveMonitor)
}

GetDesktopLeft(ActiveMonitor) {
    MonitorIndex := Convert_LeftToRightToMonitorIndex(ActiveMonitor)
    SysGet, work_area_, MonitorWorkArea, %MonitorIndex%
    return work_area_Left
}

GetCurrentDesktopWidth(use_leftmost_monitor := false) {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (use_leftmost_monitor) {
      ActiveMonitor := 0
  } else {
      ActiveMonitor := Convert_MonitorIndexToLeftToRight(GetActiveMonitorIndex())
  }

  if (DoesMonitorHaveTaskbar(ActiveMonitor) && (TaskbarEdge = "left" or TaskbarEdge = "right")) {
    return A_ScreenWidth - TW
  } else {
    return A_ScreenWidth
  }
}

GetCurrentDesktopHeight(use_leftmost_monitor := false) {
  WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,
  TaskbarEdge := GetTaskbarEdge()

  if (use_leftmost_monitor) {
      ActiveMonitor := 0
  } else {
      ActiveMonitor := Convert_MonitorIndexToLeftToRight(GetActiveMonitorIndex())
  }

  if (DoesMonitorHaveTaskbar(ActiveMonitor) && (TaskbarEdge = "top" or TaskbarEdge = "bottom")) {
    return A_ScreenHeight - TH
  } else {
    return A_ScreenHeight
  }
}

GetActiveMonitorIndex()
{
    ;; Which monitor is the active window on? Returns index understood by SysGet.
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

#f9::
    ;; Do experimentation here.
    Left0 := GetDesktopLeft(0)
    Left1 := GetDesktopLeft(1)
    Left2 := GetDesktopLeft(2)
    mindex0 := Convert_LeftToRightToMonitorIndex(0)
    mindex1 := Convert_LeftToRightToMonitorIndex(1)
    mindex2 := Convert_LeftToRightToMonitorIndex(2)
    SysGet, work0_area_, MonitorWorkArea, %mindex0%
    SysGet, work1_area_, MonitorWorkArea, %mindex1%
    SysGet, work2_area_, MonitorWorkArea, %mindex2%
    listvars
return

#f10::
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

Convert_LeftToRightToMonitorIndex(ActiveMonitor) {
    ;; Convert 0,1,2 layout to monitor index so input 0 gives index of leftmost monitor.

    if (ActiveMonitor = 0) {
        return 1
    }
    else if (ActiveMonitor = 1) {
        ;; Middle is my primary.
        return 0
    }
    else if (ActiveMonitor = 2) {
        ;; Why not 2 AHK? 2 gives the same values as 1. WHY?
        return 3
    }
    return -1
}

Convert_MonitorIndexToLeftToRight(ActiveMonitor) {
    ;; Convert monitor index to 0,1,2 layout so leftmost monitor is 0.

    ; Current layout:
    ; [1][0][2]

    if (ActiveMonitor = 0) {
        return 1
    }
    else if (ActiveMonitor = 1) {
        return 0
    }
    else if (ActiveMonitor = 2) {
        return 2
    }
    return -1
}

;; Golden ratio window movement
;; Source: https://autohotkey.com/board/topic/85457-detecting-the-screen-the-current-window-is-on/

BigGolden() {
    golden_ratio := 1.61803398875
    return 1/golden_ratio
}

SmallGolden() {
    golden_ratio := 1.61803398875
    return 1 - BigGolden()
}

ToggleGoldenRatio(use_right_side) {
    WinRestore, A
    MonitorIndex := GetActiveMonitorIndex()
    ;; TODO: Can I figure out how to make this work on other monitors?
    ;; HACK: Only monitor 1. If I use active montior, it seems to change
    ;; monitors between toggles.
    MonitorIndex := Convert_LeftToRightToMonitorIndex(1)
    SysGet, workArea, MonitorWorkArea, MonitorIndex
    workAreaWidth := workAreaRight - workAreaLeft
    workAreaHeight := workAreaBottom - workAreaTop

    ActiveMonitor := Convert_MonitorIndexToLeftToRight(MonitorIndex)
    X := GetDesktopLeft(ActiveMonitor)
    Y := GetDesktopTop(ActiveMonitor)
    WinGetPos, winX, winY, winWidth, winHeight, A
    small_width := Floor(workAreaWidth * SmallGolden())
    my_golden := 0
    if (winWidth < small_width + 1)
    {
        my_golden := BigGolden()
    }
    else
    {
        my_golden := SmallGolden()
    }
    other_golden := 1 - my_golden
    width := workAreaWidth * my_golden
    if (use_right_side) {
        X := X + workAreaRight - width
    }
    WinMove, A, , X, Y, width, workAreaHeight
}

;-=---------------------------------------------------=-;
; Win Ctrl Left         golden ratio window resize left ;
;-=---------------------------------------------------=-;

^#Left::
    ToggleGoldenRatio(false)
return

;-=---------------------------------------------------=-;
; Win Ctrl Right       golden ratio window resize right ;
;-=---------------------------------------------------=-;

^#Right::
    ToggleGoldenRatio(true)
return


ResizeAndCenter(w, h)
{
  ScreenX := GetCurrentDesktopLeft()
  ScreenY := GetCurrentDesktopTop()
  ScreenWidth := GetCurrentDesktopWidth()
  ScreenHeight := GetCurrentDesktopHeight()

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

  ;; TODO: Use GetCurrentDesktopLeft(false)? Autodetect active window and position on
  ;; its monitor?
  LeftBound := GetCurrentDesktopLeft(true)
  RightBound := A_ScreenWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := A_ScreenWidth * 2
  }
  ScreenX := LeftBound + AdjacentWidth
  ScreenY := GetCurrentDesktopTop()
  ScreenWidth := RightBound - AdjacentWidth - LeftBound
  ScreenHeight := GetCurrentDesktopHeight()

  WinMove A,,ScreenX,ScreenY,ScreenWidth,ScreenHeight
}

FitToLeftOfWin(UseRightScreen, AdjacentWidth)
{
; Put a window in the space next to my game.

  LeftBound := GetCurrentDesktopLeft(true)
  RightBound := A_ScreenWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := A_ScreenWidth * 2
  }
  ScreenX := LeftBound
  ScreenY := GetCurrentDesktopTop()
  ScreenWidth := RightBound - AdjacentWidth - LeftBound
  ScreenHeight := GetCurrentDesktopHeight()

  WinMove A,,ScreenX,ScreenY,ScreenWidth,ScreenHeight
}

FitBelowWin(UseRightScreen, AdjacentHeight, AdjacentWidth)
{
; Put a window in the space below to my game.

  LeftBound := GetCurrentDesktopLeft(true)
  RightBound := AdjacentWidth
  if UseRightScreen {
    LeftBound := A_ScreenWidth
    RightBound := AdjacentWidth + A_ScreenWidth
  }
  ScreenX := LeftBound
  ScreenY := AdjacentHeight
  ScreenWidth := AdjacentWidth
  ScreenHeight := GetCurrentDesktopHeight() - AdjacentHeight

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
  ScreenWidth := GetCurrentDesktopWidth()
  ScreenHeight := GetCurrentDesktopHeight()
  ResizeAndCenter((ScreenWidth / 2), (ScreenHeight / 2))
return

; Move window to left edge of screen

#Numpad7::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  WinMove A,,SX,SY,,
return

#Numpad4::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SH := GetCurrentDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX,SY + (SH/2) - (H/2),,
return

#Numpad1::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SH := GetCurrentDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX,SY + SH - H,,
return

; Move window to center of screen

#Numpad8::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY,,
return

#Numpad5::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  SH := GetCurrentDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY + (SH/2)-(H/2),,
return

#Numpad2::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  SH := GetCurrentDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + (SW/2)-(W/2),SY + SH-H,,
return

; Move window to right edge of screen

#Numpad9::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  WinGetPos,,,W,H,A
  WinMove A,,SX + SW-W,SY,,
return

#Numpad6::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  SH := GetCurrentDesktopHeight()
  WinGetPos,,,W,H,A
  WinMove A,,SX + SW-W,SY + (SH/2)-(H/2),,
return

#Numpad3::
  SX := GetCurrentDesktopLeft()
  SY := GetCurrentDesktopTop()
  SW := GetCurrentDesktopWidth()
  SH := GetCurrentDesktopHeight()
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

MoveAndRestore(win_id, x,y, w,h)
{
    WinRestore,%win_id%
    WinMove,%win_id%,, %x%,%y%, %w%,%h%
}
OrganizeDesktop()
{
    avoid_right_monitor := true
    ;; Lay out windows for my three monitors with centre as the work machine.
    ;; Roughly in order of left-to-right appearance.
    MoveAndRestore("ahk_exe slack.exe", GetDesktopLeft(0), GetDesktopTop(0), 1140, 1080)
    MoveAndRestore("ahk_class Vim", GetDesktopLeft(1), GetDesktopTop(1), 1294, 1447)
    ;; Game and log go here (but they position themselves).
    if (avoid_right_monitor) {
        MoveAndRestore("ahk_exe chrome.exe", GetDesktopLeft(0)+1133, GetDesktopTop(0), 732, 1080)
    } else {
        MoveAndRestore("ahk_exe chrome.exe", GetDesktopLeft(2), GetDesktopTop(0), 974, 1080)
    }
    MoveAndRestore("ahk_exe bash.exe", GetDesktopLeft(2)+953, GetDesktopTop(0), 974, 1087)

    SetTitleMatchMode 2 ;; A window's title can contain WinTitle anywhere inside it to be a match
    ;; Tortoise has lots of windows and they all have the same ahk_exe
    ;; (TortoiseProc.exe) and ahk_class (#32770). We could do try to match on
    ;; text inside the window, but the title should be pretty consistent so use
    ;; that instead.
    if (avoid_right_monitor) {
        MoveAndRestore("Working Copy - TortoiseSVN", GetDesktopLeft(2), 482, 974, 605)
    } else {
        MoveAndRestore("Working Copy - TortoiseSVN", 5433, 482, 974, 605)
    }
    SetTitleMatchMode 1 ;; Reset to default: A window's title must start with the specified WinTitle to be a match

}
#f12::
    OrganizeDesktop()
return

TileGame() {
    WinGet, window_list,List, ahk_class opengles2.0
    width := 940
    titlebar_height := 31
    height := width * 9/16 + titlebar_height
    start_x := 1920 - width
    x := start_x
    y := 0
    WinMove, dontstarve r,,x,100
    WinMinimize, dontstarve r
    Loop %window_list%
    {
        if (A_Index == window_list) {
            continue
        }
        w := window_list%A_Index%
        WinMove, ahk_id %w%,,x,y,width,height
        ; For some reason window isn't positioned at right edge of previous
        ; one! Include some padding.
        x -= width - 10
        if (x < 0) {
            x := start_x
            y += height - 10
        }
    }
    ; not sure if there's a fixed order to which is my main game window?
    ; I thought it should be the first, but last seems to work?
    w := window_list1
    w := window_list%window_list%,
    WinMove, ahk_id %w%,,3192,-196,1296,759
}

;; https://autohotkey.com/board/topic/80580-how-to-programmatically-tile-cascade-windows/
WinArrange( TC=1, aStr="", VH=0x1, Rect="", hWnd=0x0 )  {
    CreateArray( aRect, Rect )                  ; Create a RECT structure.
    IfEqual,   Rect,, SetEnv, lpRect, 0         ; determining whether lpRect is NULL
    IfNotEqual,Rect,, SetEnv, lpRect, % &aRect  ; or a pointer to the RECT Structure.
    cKids := CreateArray( aKids, aStr )         ; Create an Array of window handles.
    IfEqual,   aStr,, SetEnv, lpKids, 0         ; determining whether lpKids is NULL
    IfNotEqual,aStr,, SetEnv, lpKids, % &aKids  ; or a pointer to the array of handles.
    If ( TC= 1 ) {                               ; then the windows have to be Tiled
        Return DllCall("TileWindows",Int,hWnd,UInt,VH,UInt,lpRect,Int,cKids,Int,lpKids)
    } Else {                                     ; the windows have to be Cascaded
        IfNotEqual, VH, 4,  SetEnv,VH,0 ; If VH is 4, windows will be cascaded in ZORDER
        Return DllCall("CascadeWindows",Int,hWnd,UInt,VH,UInt,lpRect,Int,cKids,Int,lpKids)
    }
}

CreateArray( ByRef Arr, aStr="", Size=4 ) { ; complicated variant of InsertInteger()
    IfEqual, aStr,,  Return 0 ; aStr will be a pipe delimited string of integer values.
    StringReplace, aStr, aStr, |, |, All UseErrorlevel ; Calculating the no. of pipes.
    aFields := errorLevel + 1 ; errorlevel is no. of pipes, +1 results in no of fields.
    VarSetCapacity( Arr, ( aFields*Size ), 0 ) ; Initialise var length and zero fill it.
    Loop, Parse, aStr, |
    {
        Loop %Size%
            DllCall( "RtlFillMemory", UInt, &Arr+(0 pOffset)+A_Index-1 ; Thanks to Laszlo
            , UInt,1, UChar, A_LoopField >> 8*(A_Index-1) & 0xFF )
        pOffset += %Size%
    } Return aFields
}

WinArrange_TILE         := 1                    ; for Param 1
WinArrange_CASCADE      := 2                    ; for Param 1
WinArrange_VERTICAL     := 0                    ; for Param 3
WinArrange_HORIZONTAL   := 1                    ; for Param 3
WinArrange_ZORDER       := 4                    ; for Param 3
WinArrange_CLIENTAREA   := "200|25|1000|700"    ; for Param 4
; ALLWINDOWS (Param 2), ARRAYORDER (Param 3), FULLSCREEN (Param 4)
; are undeclared variables simulating NULL content.

TileGame_WindowsMethod() {
    ; Using the Windows-native DLL method seems like a good idea, but it's
    ; laggy (sometimes hangs until one of the cascaded processes is killed) and
    ; error prone. When it fails, it leaves some windows minimized.
    WinGet, window_list,List, ahk_class opengles2.0

    ; StringJoin - can't be a function and work in local scope.
    ; https://autohotkey.com/board/topic/37542-stringjoin/
    delimiter := "|"
    Loop %window_list%
    {
        t .= (t ? delimiter : "") window_list%A_Index%
    }
    windows := t

    ;; This doesn't actually work. It doesn't tile them.
    ;~ WinArrange( WinArrange_TILE, windows, WinArrange_ZORDER, WinArrange_CLIENTAREA )
    ;; Instead, we minimize everything, restore the game windows,
    ; and then tile everything.

    host_id := 0
    is_client := false
    WinMinimizeAll
    Loop, Parse, windows, |
    {
        if is_client {
            ;; Unminimize
            WinRestore, ahk_id %A_LoopField%
            ;; Move to first monitor
            WinMove, ahk_id %A_LoopField%,,100,100
        } else {
            host_id := ahk_id %A_LoopField%
        }
        ;; Unfortunantely, host doens't distinguish themself. Hopefully, they're
        ;; the first in the list.
        is_client := true
    }

    ;; Seems like some things don't occur synchronously, so these sleeps are to
    ;; ensure we've finished restoring before we tile.
    Sleep, 200
    DllCall("TileWindows",Int,0,UInt,WinArrange_HORIZONTAL,UInt,0,Int,0,Int,0)

    ;; Bring back the host.
    Sleep, 100
    WinRestore, %host_id%

    ;; Since we messed with other windows, we need to restore them.
    Sleep, 500
    OrganizeDesktop()
    ;; Slack is positioned on top of the clients.
    WinMinimize,ahk_exe slack.exe
}


#f11::
    TileGame()
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

; More shortcuts in Unity
#IfWinActive ahk_exe Unity.exe
{
    ; See Window in docs for numbers: https://docs.unity3d.com/Manual/UnityHotkeys.html

    ; Ctrl-o - find filter in Project (like unite or Visual Assist)
    ^o::
    {
        ; Ctrl-5 focuses project. Do it twice because sometimes Animator
        ; shows instead or current window is used.
        ; t:Scene will look for scenes which is my common use case.
        ; Ctrl-a to select all for easy search of anything else.
        Send ^5^5^f^at:Scene ^a
        return
    }
    ; Alt-Shift-o - open file (vanilla Ctrl-o behavior)
    !+o::
    {
        Send ^o
        return
    }
    ; Ctrl-Shift-o - find filter in Hierarchy
    ^+o::
    {
        Send ^4^f
        return
    }
}

;; Why can't I add new maps here?

; Remap capslock?
; +CapsLock::CapsLock
; CapsLock::Escape


; vim:set et sts=-1 sw=2 ts=2 fdm=marker

