version=0.2

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetTitleMatchMode, 2

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


PID := DllCall("GetCurrentProcessId")
EmptyMem(pid)
#singleinstance force
#include VA.ahk
#include JSON.ahk
#include GDIP.ahk
SysGet, VirtualScreenWidth, 78

filecreatedir, cache
GDIPToken := Gdip_Startup()  


RegWrite, REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,Lull, "%A_ScriptFullPath%"

menu, tray, nostandard
menu, tray, Icon , logo.ico
menu, tray, tip, Lull

menu, tray, add, Lull,settings 
menu, tray, add, 
menu, tray, add, Exit, cleanup

settimer, check, 100

check:
	
	
	

	WinGetTitle, title, Hulu
	StringSplit, title_a, title, -

	if (title_a0=4)
	{
		StringSplit, title_a, title_a2, :
		;cacheImages(title_a1)
		show=%title_a1%
	}
	ImageSearch, fx, fy, 0, 0, %VirtualScreenWidth%, 30, ads.png
	
	if not errorlevel
	{
		VA_SetMasterMute(True)
		;showslide(show)
	
	}
	else
	{
		VA_SetMasterMute(False)
;		gosub stopslide
		
	}
	sleep 100

return


showslide(show)
{
global
if (winexist("Lull - Please Wait"))
{
	return
}
gui, destroy
gui, -caption +alwaysontop
gui, add, picture, 0xE x0 y0 w%a_screenwidth% h%a_screenwidth%  vtheImage, 

gui, color, 131414
gui, show,NA x0 y15 w%a_screenwidth% h%a_screenwidth%, Lull - Please Wait
gui, +lastfound


WinGetPos , , , w, h
hwnd:=winexist()
hdc_WINDOW := DllCall("GetDC", UInt, hwnd)           

		hbm := CreateDIBSection(w, h)
		hdc := CreateCompatibleDC()
		obm := SelectObject(hdc, hbm)
		pGraphics:= Gdip_GraphicsFromHDC(hdc)  
Loop, cache\%show%\*,1
{
	size:=getImageSize(A_LoopFileFullPath)
	StringSplit, theSize, size , x
	newheight:=findMissing(theSize1, theSize2, a_screenwidth)
	trans=0
	loop
	{
		trans+=.1
		
		drawImage(theImage, A_LoopFileLongPath,trans,HWND, show)
		if (trans>1)
			break
		sleep 20
	}
	
	loop 20
	{
		ImageSearch, fx, fy, 0, 0, %VirtualScreenWidth%, 30, ads.png
		if ErrorLevel
			return
		sleep 500
	}
	;guicontrol, , theImage, %A_LoopFileFullPath%
	;GuiControl, MoveDraw, theImage,  w%width% h%a_screenheight%

	
}
return 
}
		



stopslide:
gui, destroy
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

cacheImages(show)
{
	show=%show%
	search=%show% tv

	url=https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%search%&imgsz=xxlarge&rsz=8
	dir=cache\%show%
	if fileexist(dir)
	{
		return
	}
	else
	{
		filecreatedir, %dir%
	}	
	UrlEncode( url )
	UrlDownloadToFile,%url% , temp.json 
	FileRead, j, temp.json 
	filedelete, temp.json
	loop
	{
		jsonQuery=responseData.results[%a_index%].url
		image:=json(j, jsonQuery)
		if image
		{
			StringGetPos, pos, image, / ,R
			
			name:=SubStr(image, pos+2 )
			
			urldownloadtofile, %image%, %dir%\%name%
		}
		else
		{
			return
		}
	}

}

UrlEncode( String )
{
   OldFormat := A_FormatInteger
   SetFormat, Integer, H

   Loop, Parse, String
   {
      if A_LoopField is alnum
      {
         Out .= A_LoopField
         continue
      }
      Hex := SubStr( Asc( A_LoopField ), 3 )
      Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
   }

   SetFormat, Integer, %OldFormat%

   return Out
}


findMissing(x,y,z)
{
	result:=(x*z)/y

	return %result%
}


drawImage(ByRef Variable, image,trans,hwnd, show,offset=0)
	{
			global
		pBitmapFile1 := Gdip_CreateBitmapFromFile(image)

		width:=Gdip_GetImageWidth( pBitmapFile1 )
		height:=Gdip_GetImageHeight( pBitmapFile1 )
		
			newwidth:=findMissing(width, height, a_screenheight)
				pos:=(A_screenwidth/2)-(newwidth/2)
					pBrush := Gdip_BrushCreateSolid(0xff131414)
					pBrushBlack := Gdip_BrushCreateSolid(0xff000000)
					;Gdip_FillRectangle(pGraphics, pBrush, 0, 0, A_screenwidth, a_screenheight)
					Gdip_FillRectangle(pGraphics, pBrushBlack, 0, 0, A_screenwidth, a_screenheight)
			Gdip_DrawImage(pGraphics, pBitmapFile1, pos, offset, newwidth, a_screenheight,0, 0, width, height, trans)
	

		Font=Arial
		fPos:=A_screenheight-100
		Options = x25 y%fPos% w80p  Bold cffffffff r4 s48 
		fPos-=2
		Gdip_FillRectangle(pGraphics, pBrush, 0, fPos, A_screenwidth, 60)
		text=%show% will return shortly
		Gdip_TextToGraphics(pGraphics, text, Options, Font, Width, Height)
	
		Gdip_DeleteBrush(pBrush)

		;UpdateLayeredWindow(hwnd, hdc,0,0, a_screenwidth, newheight)
		BitBlt(hdc_WINDOW,0,0, A_screenwidth,A_screenheight, hdc,0,0)		

	}
getImageSize(image)
{
	
	                                     ; Start GDI Plus

	pBM := Gdip_CreateBitmapFromFile( image )                ; Obtain GDI+ Handle  
	WxH := Gdip_GetImageWidth( pBM ) "x" Gdip_GetImageHeight( pBM )   ; Get Dimensions
	Gdip_DisposeImage( pBM )                                          ; Dispose image

	 
	return %WxH%
}