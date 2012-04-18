#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#singleinstance force
#include VA.ahk

RegWrite, REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,Lull, "%A_ScriptFullPath%"

menu, tray, nostandard
menu, tray, Icon , logo.ico
menu, tray, tip, Lull

menu, tray, add, Lull,settings 
menu, tray, add, 
menu, tray, add, Exit, cleanup

loop
{


	ImageSearch, fx, fy, 0, 0, %a_screenwidth%, 30, ads.png
	
	if not errorlevel
	{
		VA_SetMasterMute(True)
	
	}
	else
	{
		VA_SetMasterMute(False)
		
	}
	
}

return

settings:
	gui, font, s18, Arial
	gui, add, picture,x80, logo.png
	gui, add, text,x10, Lull
	gui, add, text,x10, Version: 0.1
	gui, add, text,x10, By Jason Stallings
	gui, show,, Lull
return

cleanup:
exitapp
