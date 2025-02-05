#SingleInstance Force
#Persistent
#NoEnv
FileEncoding, UTF-8

; �O���[�o���ϐ�
global dragGui
global imageGui
global imageControl
global dragGuiHwnd
global imageGuiHwnd
global lastX := 0
global lastY := 0

; �X�N���v�g�̃f�B���N�g�����擾
SplitPath, A_ScriptDir, , , , , 
imagePath := A_ScriptDir . "\image.png"

; �摜�̑��݊m�F
if !FileExist(imagePath) {
    MsgBox, �摜�t�@�C����������܂���: %imagePath%
    ExitApp
}

; �h���b�O�o�[�p��GUI
Gui, dragGui:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
dragGuiHwnd := WinExist()
Gui, dragGui:Margin, 0, 0
Gui, dragGui:Add, Text, w1170 h30 gGuiMove, 
Gui, dragGui:Add, Button, x1170 y0 w30 h30 gExitApp, X

; �摜�\���p��GUI
Gui, imageGui:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
imageGuiHwnd := WinExist()
Gui, imageGui:Margin, 0, 0
Gui, imageGui:Color, FEFEFE
WinSet, TransColor, FEFEFE 254

; �摜GUI�𓧉߂ɂ���
WinSet, Transparent, 32
WinSet, ExStyle, +0x20

; �摜�̓ǂݍ��݂ƕ\��
try {
    Gui, imageGui:Add, Picture, vimageControl, %imagePath%
} catch {
    MsgBox, �摜�̓ǂݍ��݂Ɏ��s���܂����B`n�p�X: %imagePath%
    ExitApp
}

; GUI��\��
Gui, dragGui:Show, x700 y170 NoActivate
Gui, imageGui:Show, x700 y200 NoActivate
return

; �h���b�O�ɂ��E�B���h�E�ړ��̏���
GuiMove:
SetTimer, WatchMovement, 10
PostMessage, 0xA1, 2
return

; �h���b�O���̈ʒu�Ď�
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

; �A�v���P�[�V�����I�����̏���
ExitApp:
dragGuiClose:
dragGuiEscape:
imageGuiClose:
imageGuiEscape:
ExitApp
return