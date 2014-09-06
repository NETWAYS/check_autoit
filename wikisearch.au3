#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
$ConfigINI = $CMDLine[1]
$SearchString1 = $CMDLine[2]
$SearchString2 = $CMDLine[3]
$ScriptTitle = ("Wiki-Search")


$URLHome = IniRead($ConfigINI, "wiki", "urlhome", "www.heise.de")



#include <ie.au3>

; start Timeline
$timeline = TimerInit()

$oIE = _IECreate ($URLHome)
If IsObj($oIE) Then
_IELoadWait($oIE)
$oForm = _IEFormGetObjByName($oIE, "searchform")
$IESearch = _IEFormElementGetObjByName($oForm, "search")
_IEFormElementSetValue($IESearch, $SearchString1)
$IESend = _IEFormElementGetObjByName($oForm, "fulltext")
;_IEFormElementSetValue($oPasswd, $Passwort)
_IEFormSubmit($oForm)
_IELoadWait($oIE)
$oForm = _IEFormGetObjByName($oIE, "searchform")
$IESearch = _IEFormElementGetObjByName($oForm, "search")
_IEFormElementSetValue($IESearch, $SearchString2)
$IESend = _IEFormElementGetObjByName($oForm, "fulltext")
;_IEFormElementSetValue($oPasswd, $Passwort)
_IEFormSubmit($oForm)
_IELoadWait($oIE)


WinClose($oIE)


Else

ConsoleWriteError("ERROR!!! No Internet Explorer Task startet")
exit(3)
EndIf


$dif = TimerDiff($timeline) / 1000
$result = StringLeft($dif, 5)
;ConsoleWrite("" & $result)
exit("" & $result)
