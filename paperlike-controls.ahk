#NoEnv
#Include MDMF.ahk
Monitors := MDMF_Enum()
Gui, Margin, 20, 20
Gui, +OwnDialogs
Gui, Add, ListView, w660 r10 Grid, HMON|Num|Name|Primary|Left|Top|Right|Bottom|WALeft|WATop|WARight|WABottom
For HMON, M In Monitors {
   LV_Add("", HMON, M.Num, M.Name, M.Primary, M.Left, M.Top, M.Right, M.Bottom, M.WALeft, M.WATop, M.WARight, M.WABottom)   
}

DllCall("GetDisplayConfigBufferSizes", "uint", QDC_ONLY_ACTIVE_PATHS := 2, "uint*", numPathArrayElements, "uint*", numModeInfoArrayElements)
VarSetCapacity(DISPLAYCONFIG_PATH_INFO, (20+48+4)*numPathArrayElements, 0)
VarSetCapacity(DISPLAYCONFIG_MODE_INFO, 64*numModeInfoArrayElements, 0)
DllCall("QueryDisplayConfig", "uint", QDC_ONLY_ACTIVE_PATHS := 2, "ptr", &numPathArrayElements, "ptr", &DISPLAYCONFIG_PATH_INFO, "ptr", &numModeInfoArrayElements, "ptr", &DISPLAYCONFIG_MODE_INFO, "uint", 0)
loop % NumGet(numPathArrayElements, "int")
{
   adapterId := NumGet(DISPLAYCONFIG_PATH_INFO, (A_Index-1)*72+20, "int64")
   id := NumGet(DISPLAYCONFIG_PATH_INFO, (A_Index-1)*72+28, "uint")
   VarSetCapacity(DISPLAYCONFIG_TARGET_DEVICE_NAME, 420, 0)
   NumPut(DISPLAYCONFIG_DEVICE_INFO_GET_TARGET_NAME := 2, DISPLAYCONFIG_TARGET_DEVICE_NAME, 0, "uint")
   NumPut(420, DISPLAYCONFIG_TARGET_DEVICE_NAME, 4, "uint")
   NumPut(adapterId, DISPLAYCONFIG_TARGET_DEVICE_NAME, 8, "int64")
   NumPut(id, DISPLAYCONFIG_TARGET_DEVICE_NAME, 16, "uint")
   DllCall("DisplayConfigGetDeviceInfo", "ptr", &DISPLAYCONFIG_TARGET_DEVICE_NAME)
   MsgBox, % StrGet(&DISPLAYCONFIG_TARGET_DEVICE_NAME + 36)
}

wmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\wmi")
for monitor in wmi.ExecQuery("Select * from WmiMonitorID") {
	fname :=
	for char in monitor.InstanceName
		fname .= chr(char)
    Msgbox, %fname%
    fname := monitor.InstanceName
	Msgbox, %fname%
    fname :=
	for char in monitor.UserFriendlyName
		fname .= chr(char)
    Msgbox, %fname%
}

VarSetCapacity(Display_Device, 840, 0)
NumPut(840, Display_Device)
DllCall("EnumDisplayDevices", "Ptr", 0, "UInt", 2, "Ptr", &Display_Device, "UInt", 1)
DeviceName := StrGet(&Display_Device + 4, 32)
DeviceString := StrGet(&Display_Device + 4 + 32*2, 128)
DeviceID := StrGet(&Display_Device + 4 + 32*2 + 128*2 + 4, 128)
DeviceKey := StrGet(&Display_Device + 4 + 32*2 + 128*2 + 4 + 128, 128)
MsgBox, %DeviceName%, %DeviceString%, %DeviceID%, %DeviceKey%
DllCall("EnumDisplayDevices", "WStr", "\\.\DISPLAY3", "UInt", 0, "Ptr", &Display_Device, "UInt", 0)
DeviceName := StrGet(&Display_Device + 4, 32)
DeviceString := StrGet(&Display_Device + 4 + 32*2, 128)
DeviceID := StrGet(&Display_Device + 4 + 32*2 + 128*2 + 4, 128)
DeviceKey := StrGet(&Display_Device + 4 + 32*2 + 128*2 + 4 + 128, 128)
MsgBox, %DeviceName%, %DeviceString%, %DeviceID%, %DeviceKey%
Loop, % LV_GetCount("Column")
   LV_ModifyCol(A_Index, "AutoHdr")
Gui, Add, Text,, Function
Gui, Add, Edit
Gui, Add, UpDown, vVCPCode Range0-15, 6
Gui, Add, Text,, Value
Gui, Add, Edit
Gui, Add, UpDown, vVCPValue Range0-255, 2
Gui, Add, Button, Default, OK
Gui, Show, ,Monitors
Return
ButtonOK:
Gui, Submit, NoHide
LV_GetText(hMon, 1, 1)
VarSetCapacity(Physical_Monitor, 8 + 128, 0)
result := DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR", "Ptr", hMon+0, "uint", 1, "Ptr", &Physical_Monitor)
hPhysMon := NumGet(Physical_Monitor)
Description := StrGet(&Physical_Monitor+8)
;MsgBox, %result% %hPhysMon% %Description%
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0301) ;monitor off
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0302) ;monitor on (needs clear)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0602) ;clear ghost
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0701) ;M1
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0702) ;M2
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0703) ;M3
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0801) ;Contrast min
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0809) ;Contrast max
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0C01) ;Speed++
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0C02) ;Speed+
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0C03) ;Common
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0C04) ;Dark+
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0C05) ;Dark++
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0Exx) ;Light1 intensity
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 0x08, "UInt", 0x0Fxx) ;Light2 intensity

;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0703)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0801)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0C03)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0602)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0301)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0410)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x0602)

result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", 8, "UInt", VCPCode*256 + VCPValue)
;MsgBox, %result%, %A_LastError%, %VCPCode%, %VCPValue%
Return
GuiClose:
ExitApp
