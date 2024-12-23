#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

; Win + C to toggle the GIPHY picker
#c::
    ToggleGiphyPicker()
return

ToggleGiphyPicker() {
    static isOpen := false
    
    if (isOpen) {
        WinClose, GIPHY Picker
        isOpen := false
    } else {
        Run, % "file://" . A_ScriptDir . "/giphy_picker.html"
        isOpen := true
    }
}

; Escape key to close the picker
#IfWinActive GIPHY Picker
Escape::
    WinClose, A
return 