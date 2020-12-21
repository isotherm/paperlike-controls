#SingleInstance,Force
SetBatchLines,-1
Gui,1:+AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
Gui,1:Show,x0 w1 h1650 NA,Moving window
Gui, Color, WindowColor000000
return
GuiClose:
GuiContextMenu:
*Esc::
	ExitApp
Numpad1::
	X:=0,Stop:=0
	DllCall("QueryPerformanceFrequency", "Int64*", freq)
	DllCall("QueryPerformanceCounter", "Int64*", TotalTimeStartTime)
	DllCall("QueryPerformanceCounter", "Int64*", StartTime)
	While(x<2200&&!Stop){
		DllCall("QueryPerformanceCounter", "Int64*", EndTime)
		if(((EndTime-StartTime)/freq * 1000 )>1000/20){
			DllCall("QueryPerformanceCounter", "Int64*", StartTime)
			Gui,1:Show,% "x" x++ " NA" 
			;sleep,20
		}
	}
	DllCall("QueryPerformanceCounter", "Int64*", EndTime)
	Total_Time:=(EndTime-TotalTimeStartTime)/freq
	msgbox, The total time was %Total_Time% Seconds.`nThe Best time would be 80 seconds`n`n`ti.e 1920/24 = 80
	return
numpad2::
	Stop:=1
	return