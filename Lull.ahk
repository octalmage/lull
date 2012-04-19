version=0.2

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetTitleMatchMode, 2

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


PID := DllCall("GetCurrentProcessId")
EmptyMem(pid)
#singleinstance force
#include VA.ahk
SysGet, VirtualScreenWidth, 78

RegWrite, REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,Lull, "%A_ScriptFullPath%"

menu, tray, nostandard
menu, tray, Icon , logo.ico
menu, tray, tip, Lull

menu, tray, add, Lull,settings 
menu, tray, add, 
menu, tray, add, Exit, cleanup

loop
{
	if !WinExist("Hulu -")
	{
		EmptyMem(pid)
		sleep 5000
		return
	}

	ImageSearch, fx, fy, 0, 0, %VirtualScreenWidth%, 30, ads.png
	
	if not errorlevel
	{
		VA_SetMasterMute(True)
	
	}
	else
	{
		VA_SetMasterMute(False)
		
	}
	sleep 100
}

return

settings:
	gui, font, s18, Arial
	gui, add, picture,x80, logo.png
	gui, add, text,x10, Lull
	gui, add, text,x10, Version: %version%
	gui, add, text,x10, By Jason Stallings
	gui, show,, Lull
return

cleanup:
exitapp

EmptyMem(pid){
pid:=(pid) ? DllCall("GetCurrentProcessId") : pid
h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
DllCall("CloseHandle", "Int", h)
}