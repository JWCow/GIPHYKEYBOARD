#NoEnv  ; Recommended for performance and compatibility
#SingleInstance Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Set GIPHY icon
if (FileExist("giphy_icon.ico")) {
    Menu, Tray, Icon, %A_ScriptDir%\giphy_icon.ico
} else {
    Menu, Tray, Icon, C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
}

; Set up tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Show GIPHY Keyboard, ShowPicker
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Default, Show GIPHY Keyboard
Menu, Tray, Click, 1

; Global variables
global width := 400
global height := 600
global edgePath := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global htmlPath := A_ScriptDir "\giphy_picker.html"
htmlPath := StrReplace(htmlPath, "\", "/")
htmlPath := StrReplace(htmlPath, " ", "%20")
htmlPath := StrReplace(htmlPath, ":", "%3A")

; Pre-load Edge instance on script start
PreloadEdge() {
    Run, % edgePath 
        . " --app=""file:///" htmlPath """"
        . " --window-size=1,1"
        . " --window-position=-9999,-9999"
        . " --disable-extensions"
        . " --disable-plugins"
        . " --disable-sync"
        . " --no-first-run"
        . " --noerrdialogs"
        . " --disable-translate"
        . " --disable-features=TranslateUI"
        . " --disable-save-password-bubble"
        . " --no-default-browser-check"
        . " --hide-scrollbars"
        . " --disable-notifications"
        . " --disable-background-mode"
        . " --disable-backing-store-limit"
        . " --disable-pinch"
        . " --disable-features=msEdgeStable"
        . " --disable-features=msEdgeUpdate"
        . " --disable-features=msEdgeSyncServiceFeatures"
        . " --disable-features=msEdgePasswordManager"
        . " --user-data-dir=""" A_Temp "\GiphyPicker"""
    
    WinWait, GIPHY Picker
    WinHide, GIPHY Picker
}

ShowPicker:
    if WinExist("GIPHY Picker") {
        WinGet, state, MinMax, GIPHY Picker
        WinGetPos, x, y, w, h, GIPHY Picker
        
        ; If window is minimized or wrong size, restore it properly
        if (state = -1 || w != width || h != height) {
            x := (A_ScreenWidth - width) / 2
            y := (A_ScreenHeight - height) / 2
            WinMove, GIPHY Picker,, x, y, width, height
            WinRestore, GIPHY Picker
        }
        
        WinShow, GIPHY Picker
        WinActivate, GIPHY Picker
    } else {
        x := (A_ScreenWidth - width) / 2
        y := (A_ScreenHeight - height) / 2
        
        Run, % edgePath
            . " --app=""file:///" htmlPath """"
            . " --window-size=" width "," height 
            . " --window-position=" Round(x) "," Round(y)
            . " --disable-extensions"
            . " --disable-plugins"
            . " --disable-sync"
            . " --no-first-run"
            . " --noerrdialogs"
            . " --disable-translate"
            . " --disable-features=TranslateUI"
            . " --disable-save-password-bubble"
            . " --no-default-browser-check"
            . " --hide-scrollbars"
            . " --disable-notifications"
            . " --disable-background-mode"
            . " --disable-backing-store-limit"
            . " --disable-pinch"
            . " --disable-features=msEdgeStable"
            . " --disable-features=msEdgeUpdate"
            . " --disable-features=msEdgeSyncServiceFeatures"
            . " --disable-features=msEdgePasswordManager"
            . " --user-data-dir=""" A_Temp "\GiphyPicker"""
        
        WinWait, GIPHY Picker
        WinActivate, GIPHY Picker
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
