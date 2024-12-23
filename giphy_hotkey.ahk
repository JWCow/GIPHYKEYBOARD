#NoEnv  ; Recommended for performance and compatibility
#SingleInstance Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Win + C to toggle GIPHY picker
#c::
    if WinExist("GIPHY Picker")
    {
        WinClose
    }
    else
    {
        ; Calculate center position for a 400x600 window
        width := 400
        height := 600
        x := (A_ScreenWidth - width) / 2
        y := (A_ScreenHeight - height) / 2
        
        ; Get absolute path and convert to proper URL format
        htmlPath := A_ScriptDir "\giphy_picker.html"  ; Direct path to HTML file
        htmlPath := StrReplace(htmlPath, "\", "/")
        htmlPath := StrReplace(htmlPath, " ", "%20")
        htmlPath := StrReplace(htmlPath, ":", "%3A")
        
        ; Create and run the command
        Run, % "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
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
    }
return

; Close with Escape key
#IfWinActive GIPHY Picker
Esc::WinClose
#IfWinActive
