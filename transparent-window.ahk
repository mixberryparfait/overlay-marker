#SingleInstance Force
#Persistent
#NoEnv
FileEncoding, UTF-8

; グローバル変数
global dragGui
global imageGui
global imageControl
global dragGuiHwnd
global imageGuiHwnd
global lastX := 0
global lastY := 0

; スクリプトのディレクトリを取得
SplitPath, A_ScriptDir, , , , , 
imagePath := A_ScriptDir . "\image.png"

; 画像の存在確認
if !FileExist(imagePath) {
    MsgBox, 画像ファイルが見つかりません: %imagePath%
    ExitApp
}

; ドラッグバー用のGUI
Gui, dragGui:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
dragGuiHwnd := WinExist()
Gui, dragGui:Margin, 0, 0
Gui, dragGui:Add, Text, w1170 h30 gGuiMove, 
Gui, dragGui:Add, Button, x1170 y0 w30 h30 gExitApp, X

; 画像表示用のGUI
Gui, imageGui:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
imageGuiHwnd := WinExist()
Gui, imageGui:Margin, 0, 0
Gui, imageGui:Color, FEFEFE
WinSet, TransColor, FEFEFE 254

; 画像GUIを透過にする
WinSet, Transparent, 32
WinSet, ExStyle, +0x20

; 画像の読み込みと表示
try {
    Gui, imageGui:Add, Picture, vimageControl, %imagePath%
} catch {
    MsgBox, 画像の読み込みに失敗しました。`nパス: %imagePath%
    ExitApp
}

; GUIを表示
Gui, dragGui:Show, x700 y170 NoActivate
Gui, imageGui:Show, x700 y200 NoActivate
return

; ドラッグによるウィンドウ移動の処理
GuiMove:
SetTimer, WatchMovement, 10
PostMessage, 0xA1, 2
return

; ドラッグ中の位置監視
WatchMovement:
WinGetPos, dragX, dragY, dragW, dragH, ahk_id %dragGuiHwnd%
if (dragX != lastX || dragY != lastY) {
    lastX := dragX
    lastY := dragY
    WinMove, ahk_id %imageGuiHwnd%, , %dragX%, % dragY + dragH
}

GetKeyState, state, LButton, P
if state = U
{
    SetTimer, WatchMovement, Off
}
return

; アプリケーション終了時の処理
ExitApp:
dragGuiClose:
dragGuiEscape:
imageGuiClose:
imageGuiEscape:
ExitApp
return