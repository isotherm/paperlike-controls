#NoEnv
#Include MDMF.ahk
Monitors := MDMF_Enum()
Gui, Margin, 20, 20
Gui, +OwnDialogs
Gui, Add, ListView, w660 r10 Grid, HMON|Num|Name|Primary|Left|Top|Right|Bottom|WALeft|WATop|WARight|WABottom
For HMON, M In Monitors {
   LV_Add("", HMON, M.Num, M.Name, M.Primary, M.Left, M.Top, M.Right, M.Bottom, M.WALeft, M.WATop, M.WARight, M.WABottom)
   
}
Loop, % LV_GetCount("Column")
   LV_ModifyCol(A_Index, "AutoHdr")
Gui, Add, Text,, VCPCode
Gui, Add, Edit, vVCPCode Limit2, 08
Gui, Add, Text,, VCPValue
Gui, Add, Edit, vVCPValue Limit4
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
result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x401)
Sleep 5000
result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", 0x4FF)
;result := DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "UChar", "0x".VCPCode, "UInt", "0x".VCPValue)
;MsgBox, %result%, %A_LastError%, %VCPCode%, %VCPValue%
Return
GuiClose:
ExitApp
