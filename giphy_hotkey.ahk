#NoEnv  ; Recommended for performance and compatibility
#SingleInstance Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Global variables
global width := 400
global height := 600
global htmlPath := A_ScriptDir "\giphy_picker.html"
global iniFile := A_ScriptDir "\giphy_settings.ini"
htmlPath := StrReplace(htmlPath, "\", "/")
htmlPath := StrReplace(htmlPath, " ", "%20")
htmlPath := StrReplace(htmlPath, ":", "%3A")

; Pre-load browser instance on script start
PreloadBrowser() {
    Run, % "file:///" htmlPath
    WinWait, GIPHY Picker
    WinHide, GIPHY Picker
}

PreloadBrowser()

ShowPicker:
    if WinExist("GIPHY Picker") {
        WinGet, state, MinMax, GIPHY Picker
        if (state = -1) {  ; If window is minimized
            WinRestore, GIPHY Picker  ; Restore it
            WinActivate, GIPHY Picker
        } else {  ; If window is normal/visible
            WinMinimize, GIPHY Picker  ; Minimize it
        }
    } else {
        x := (A_ScreenWidth - width) / 2
        y := (A_ScreenHeight - height) / 2
        
        Run, % "file:///" htmlPath
        
        WinWait, GIPHY Picker
        WinGet, state, MinMax, GIPHY Picker
        if (state = -1) {
            WinRestore, GIPHY Picker
        }
        WinShow, GIPHY Picker
        WinActivate, GIPHY Picker
        
        ; Ensure proper size and position
        WinMove, GIPHY Picker,, x, y, width, height
    }
return

; Win + C to toggle GIPHY picker
#c::
Goto, ShowPicker
return

; Close with Escape key
#IfWinActive GIPHY Picker
Esc::
    WinMinimize, GIPHY Picker
    WinHide, GIPHY Picker
return
#IfWinActive

ExitScript:
ExitApp

#IfWinActive GIPHY Picker
; Add arrow key navigation for GIFs
Up::Send {WheelUp}
Down::Send {WheelDown}
; Tab to focus next GIF
Tab::Send {Tab}
; Ctrl+Enter to quickly copy focused GIF
^Enter::Send ^c
#IfWinActive

SaveWindowPosition() {
    WinGetPos, x, y,,, GIPHY Picker
    IniWrite, %x%, %iniFile%, Window, X
    IniWrite, %y%, %iniFile%, Window, Y
}

LoadWindowPosition() {
    IniRead, savedX, %iniFile%, Window, X, DEFAULT
    IniRead, savedY, %iniFile%, Window, Y, DEFAULT
    if (savedX != "DEFAULT" && savedY != "DEFAULT") {
        x := savedX
        y := savedY
    } else {
        x := (A_ScreenWidth - width) / 2
        y := (A_ScreenHeight - height) / 2
    }
    return [x, y]
}

GetActiveMonitorCenter() {
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    SysGet, monCount, MonitorCount
    
    Loop, %monCount% {
        SysGet, mon, Monitor, %A_Index%
        if (mouseX >= monLeft && mouseX <= monRight && mouseY >= monTop && mouseY <= monBottom) {
            x := monLeft + (monRight - monLeft - width) / 2
            y := monTop + (monBottom - monTop - height) / 2
            return [x, y]
        }
    }
    ; Fallback to primary monitor
    return [(A_ScreenWidth - width) / 2, (A_ScreenHeight - height) / 2]
}
