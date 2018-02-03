#include <GuiConstants.au3>
#include <Timers.au3>
#include <WindowsConstants.au3>

Global $s, $mn, $DegToRad = 3.14159265358979/180, $BallX, $BallY, $z, $resp, $RespCount
AutoItSetOption("WinTitleMatchMode", 2) ; see "options" in help for title match mode

$MyGUI = GUICreate("Coh�rence cardiaque", @DesktopHeight/2, @DesktopWidth/2.5, -1, -1, $WS_OVERLAPPEDWINDOW, $WS_SIZEBOX)
Global $size = WinGetPos("Coh�rence cardiaque")
GUISetBkColor(0xAAAAFF)
$Start = GUICtrlCreateButton("Start", 10, 10, 50, 20)
$Info = GUICtrlCreateButton("i", $size[2]-45, 10, 20, 20)
GUISetFont(10, 800, 2, "Arial")
;GUICtrlCreateLabel("T", 0, 10, 50, 20)
;GUICtrlCreateLabel("s", 0, 30, 50, 20)
$Rlabel = GUICtrlCreateLabel("Respirations", $size[2]/5-32, $size[3]/4, 200, 20)
$Mlabel = GUICtrlCreateLabel("Dur�e", 3*$size[2]/4-20, $size[3]/4, 200, 20)
;$TimerLabel = GUICtrlCreateLabel("0", 30, 10, 50, 20)
;$sLabel = GUICtrlCreateLabel("0", 30, 30, 50, 20)
$respLabel = GUICtrlCreateLabel("", $size[2]/5, $size[3]/4+50, 50, 20)
$mnLabel = GUICtrlCreateLabel("", 3*$size[2]/4-20, $size[3]/4+50, 80, 20)
GUISetState(@SW_SHOW)

$MyGUI2 = GUICreate("Graphic", 50, 50, 0, 0, $WS_POPUP, $WS_EX_LAYERED)
$Ball = GUICtrlCreatePic("Src\ball.gif", $BallX, $BallY, 50, 50)
WinSetOnTop("Graphic", "", 1)

Reset()
Func Reset()
   WinSetState($MyGUI2, "", @SW_HIDE)
   $s = 0
   $z = -90
   $resp = 0
   $respCount = 0
   $mn = 0
   GUICtrlSetData($mnLabel, "00 : 00")
   GUICtrlSetData($respLabel, $respCount)
   $MoveX = $size[0]-25+$size[2]/2
   $y = Sin($z*$DegToRad)*($size[3]-110)/2
   $MoveY = $size[1]+$size[3]/2-15-$y
   WinMove("Graphic","",  $MoveX, $MoveY)
EndFunc

SoundPlay("Src\ding.wav")
While 1
   $msg = GUIGetMsg()
   Select
	  Case $Msg = $GUI_EVENT_CLOSE
		 ExitLoop
	  Case $msg = $Start
		 $TestStartButton = GUICtrlRead($Start)
		 If $TestStartButton = "Start" Then
			GUICtrlSetData($Start, "Reset")
			$Timer = TimerInit()
			_Timer_SetTimer($MyGUI, 998.9999999999985, "Sec")
			$TimerAFF = _Timer_SetTimer($MyGUI, 40, "Aff")
			WinSetState($MyGUI2, "", @SW_SHOW)
		 Else
			GUICtrlSetData($Start, "Start")
			_Timer_KillAllTimers($MyGUI)
			Reset()
		 EndIf
	  Case $msg = $Info
		 Info()
   EndSelect
WEnd
_Timer_KillAllTimers($MyGUI)

Func Sec($a, $b, $c, $d)
   $TimerAFF = TimerInit()
   $s += 1
   ;GUICtrlSetData($sLabel, $s)
   ;GUICtrlSetData($TimerLabel, int(TimerDiff($Timer)))
   If $s == 60 Then
	  $mn +=1
	  $s = 0
   EndIf
   If $mn < 10 Then
	  If $s < 10 Then
		 GUICtrlSetData($mnLabel, "0"&$mn&" : 0"&$s)
	  Else
		 GUICtrlSetData($mnLabel, "0"&$mn&" : "&$s)
	  EndIf
   Else
	  If $s < 10 Then
		 GUICtrlSetData($mnLabel, $mn&" : 0"&$s)
	  Else
		 GUICtrlSetData($mnLabel, $mn&" : "&$s)
	  EndIf
   EndIf
   $resp += 1
   If $resp == 5 Then
	  SoundPlay("Src\ding.wav")
   EndIf
   If $resp == 10 Then
	  SoundPlay("Src\ding_bas.wav")
	  $respCount +=1
	  GUICtrlSetData($respLabel, $respCount)
	  $Resp = 0
   Endif
EndFunc

Func Aff($a, $b, $c, $d)
   $z = TimerDiff($Timer)/27.818-90
   
   ;if Sin($z*$DegToRad) > 0.9999 then GUICtrlSetData($bestLabel, Int(TimerDiff($Timer))/1000)
   ;if Sin($z*$DegToRad) == 1 then GUICtrlSetData($hitLabel, Int(TimerDiff($Timer))/1000)
   ;if Sin($z*$DegToRad) == -1 then GUICtrlSetData($hit0Label, Int(TimerDiff($Timer))/1000)
   ;if Sin($z*$DegToRad) < -0.9999 then GUICtrlSetData($best0Label, Int(TimerDiff($Timer))/1000)
   
   Local $size = WinGetPos("Coh�rence cardiaque")
   $MoveX = $size[0]-25+$size[2]/2
   $y = Sin($z*$DegToRad)*($size[3]-110)/2
   $MoveY = $size[1]+$size[3]/2-15-$y
   WinMove("Graphic","",  $MoveX, $MoveY)
EndFunc

Func Info()
   SplashImageOn("Coh�rence cardiaque","Src\coherence_cardiaque.jpg", 300, 227, 100, 300, 16)
   MsgBox(64, "Coh�rence cardiaque", "La coh�rence cardiaque, explications selon David Servan-Schreiber : "&@CRLF&@CRLF&"Deux branches relient le cerveau �motionnel et le coeur : la branche sympathique fonctionne avec l'adr�naline pour acc�l�rer le coeur en cas de besoin (danger, action), et la branche parasympathique r�duit le rythme cardiaque (digestion, r�g�n�ration)."&@CRLF&"Ces deux branches fonctionnent dans les deux sens, le coeur peut donc influencer le cerveau. Le couple coeur/cerveau r�gule notre relation au monde ext�rieur et � notre physiologie interne."&@CRLF&"L'�lectrocardiogramme repr�sente les battements du coeur dans le temps. Bien que r�guliers, les battements ne sont jamais exactement r�guliers � la milliseconde pr�s.  Il y a des variations irr�guli�res, qui font que les battements varient entre 50 et 90 bpm."&@CRLF&"Lors de la coh�rence cardiaque, les variations se structurent, elle prennent un rythme. Le coeur et le cerveau s'accordent mieux, les variations deviennent r�guli�res dans le temps. Cet �tat aide � combattre le stress et apporte une coh�rence entre nos perceptions du monde ext�rieur et notre physiologie interne."&@CRLF&"Il est possible d'atteindre la coh�rence cardiaque gr�ce � un exercice simple de respiration : Une inspiration de 5 secondes suivie d'une expiration de 5 secondes permettent un rythme de 6 respirations par minutes. C'est ce rythme qui offre les meilleures chances d'�tre en coh�rence cardiaque."&@CRLF&"La dur�e conseill� est de 5 minutes. La position conseill�e est la position assise, dos droit et t�te droite, les pieds � plat. Il est conseill� de r�aliser 3 fois cet exercice dans la journ�e. Enfin, il est conseill� de r�guli�rement se demander ce qui a chang� depuis la pratique de l'exercice. C'est apr�s plusieurs semaines que vous aurez compris les b�n�fices de la coh�rence cardiaque."&@CRLF&"http://www.coherencecardiaque.org/"&@CRLF&@CRLF&"David Palpacuer 2013")
   SplashOff()
EndFunc