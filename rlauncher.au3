#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

; #INDEX# =======================================================================================================================
; Title .........: rLauncher
; Version .......: 1.0
; AutoIt Version : 3.3.14.2
; Language ......: MultiLanguage via config file (.ini)
; Description ...: Small launcher script for removable drives
; Author(s) .....: Eduardo Mota
; Dll ...........: -
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_init
;_baseload_iniread
;_update
;_launch
; ===============================================================================================================================

; #GLOBAL VARS# =================================================================================================================
; Name...........: Global variables
; Description ...: Essential global variables to the script
; ===============================================================================================================================
Global 	$file_bins = "bins.list", $file_categorias = "categoria.list", _	; Script files
		$file_config = "launcher.cfg", _									; Script config file
		$counter_bins, $counter_categorias, _								; Script counter vars
		$binaries, $categories, _											; Script binaries and categories
		$file_sect_config = "config"										; Script config file section

; #CONFIG VARS# =================================================================================================================
; Name...........: Configuration variables
; Description ...: Script configuration variables
; ===============================================================================================================================
Global $config_updtonlaunch, _		; Update list on launch (1 - yes, 0 - no)
	   $config_scriptlang, _		; Script language via (.ini) (pt_PT, en_US, ...)
	   $config_clseonlnch, _		; Close on launch (1 - yes, 0 - no)
	   $config_topmost				; Is window Topmost (1 - yes, 0 - no)

; #LANGUAGE VARS# ===============================================================================================================
; Name...........: Language variables
; Description ...: Language variables to localize script
; ===============================================================================================================================
Global $lang_gui, _			; GUI Title
	   $lang_gui_bininit, _	; GUI binary start button
	   $lang_gui_getinfo, _	; GUI get info button
	   $lang_gui_label2, _	; GUI binary name label
	   $lang_gui_label3, _	; GUI category name label
	   $lang_gui_update, _	; GUI update button
	   $lang_error_title = "Erro!", _											; Error file not found title
	   $lang_error_message1 = "Existem 1 ou mais ficheiros em falta..", _		; Error file not found message
	   $lang_error_message2	= "Confira se existem os seguintes ficheiros:", _	; Error file not found message
	   $lang_error_nobin, _														; Error no binaries
	   $lang_error_nocat, _														; Error no categories
	   $lang_gui_loading	; Loading data

; #GUI VARS# ====================================================================================================================
; Name...........: Graphic User Interface Variables
; Description ...: -
; ===============================================================================================================================
Global $gui, _					; GUI window
	   $gui_binlist, _ 			; GUI bin list
	   $gui_bininit 			; GUI bin button init
	   ;$gui_getinfo, _			; GUI info button (disabled)
	   ;$gui_label1, _			; GUI label 1 (disabled)
Global $gui_categoriaslist, _	; GUI categories list
	   $gui_label2, _			; GUI Name label
	   $gui_label3, _	 		; GUI Category Label
	   $gui_update 				; GUI update button

_init()

; #FUNCTION# ====================================================================================================================
; Name...........: _init
; Description ...: Load configurations, checks files and start user interface
; Syntax.........: _init()
; Parameters ....: -
; Return values .: -
; ===============================================================================================================================
Func _init()

	; Check if any files are missing
	If Not FileExists($file_bins) Or Not FileExists($file_categorias) Or Not FileExists($file_config) Then
		MsgBox(0,$lang_error_title,$lang_error_message1 & @CRLF & $lang_error_message2 & @CRLF & $file_bins & @CRLF & $file_categorias & @CRLF & $file_config)
		Exit
	EndIf

	; Load base configs
	$config_updtonlaunch 	= _baseload_iniread($file_sect_config, "config_updtonlaunch", 1)
	$config_scriptlang 		= _baseload_iniread($file_sect_config, "config_scriptlang", "pt_PT")
	$config_clseonlnch 		= _baseload_iniread($file_sect_config, "config_clseonlnch", 0)
	$config_topmost			= _baseload_iniread($file_sect_config, "config_topmost", 0)

	; Load lang section
	$lang_gui				= _baseload_iniread($config_scriptlang, "lang_gui", "_/ A Minha Drive _/")
	$lang_gui_bininit		= _baseload_iniread($config_scriptlang, "lang_gui_bininit", "Iniciar")
	$lang_gui_getinfo		= _baseload_iniread($config_scriptlang, "lang_gui_getinfo", "Informação")
	$lang_gui_label2		= _baseload_iniread($config_scriptlang, "lang_gui_label2", "Nome:")
	$lang_gui_label3		= _baseload_iniread($config_scriptlang, "lang_gui_label3", "Categoria:")
	$lang_gui_update		= _baseload_iniread($config_scriptlang, "lang_gui_update", "Actualizar")
	$lang_error_title		= _baseload_iniread($config_scriptlang, "lang_error_title", "Erro!")
	$lang_error_message1	= _baseload_iniread($config_scriptlang, "lang_error_message1", "Existem 1 ou mais ficheiros em falta..")
	$lang_error_message2	= _baseload_iniread($config_scriptlang, "lang_error_message2", "Confira se existem os seguintes ficheiros:")
	$lang_error_nobin		= _baseload_iniread($config_scriptlang, "lang_error_nobin", "Sem Programas")
	$lang_error_nocat		= _baseload_iniread($config_scriptlang, "lang_error_nocat", "Sem categorias")
	$lang_gui_loading		= _baseload_iniread($config_scriptlang, "lang_gui_loading", "A carregar dados...")

	; Load GUI
	If $config_topmost = 1 Then $gui = GUICreate($lang_gui, 203, 329, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE)); GUI window
	If $config_topmost = 0 Then $gui = GUICreate($lang_gui, 203, 329, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))			; GUI window
	$gui_binlist = GUICtrlCreateList("", 8, 136, 185, 110,BitOR($GUI_SS_DEFAULT_LIST,$WS_BORDER, $LBS_SORT))		; GUI bin list
	$gui_bininit = GUICtrlCreateButton($lang_gui_bininit, 8, 256, 185, 66, $BS_DEFPUSHBUTTON)						; GUI bin button init
	;$gui_getinfo = GUICtrlCreateButton($lang_gui_getinfo, 8, 288, 185, 33)
	;$gui_label1 = GUICtrlCreateLabel("", 8, 8, 4, 4)
	$gui_categoriaslist = GUICtrlCreateList("", 8, 32, 185, 71,BitOR($GUI_SS_DEFAULT_LIST,$WS_BORDER, $LBS_SORT))	; GUI categories list
	$gui_label2 = GUICtrlCreateLabel($lang_gui_label2, 16, 114, 35, 17)												; GUI Name label
	$gui_label3 = GUICtrlCreateLabel($lang_gui_label3, 16, 10, 52, 17)												; GUI Category Label
	$gui_update = GUICtrlCreateButton($lang_gui_update, 120, 2, 75, 25)												; GUI update button
	GUISetState(@SW_SHOW)

	If $config_updtonlaunch <> 0 Then _update()	; Update if option is active
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE		; On window close
				Exit

			Case $gui_categoriaslist 	; On category choose
				_update(1)

			Case $gui_bininit			; On binary start
				_launch()

			;Case $gui_getinfo			; Disabled feature
			Case $gui_binlist			; On binary choose

			Case $gui_update			; On GUI update button
				_update(1)
		EndSwitch
	WEnd

EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _baseload_iniread
; Description ...: Simpler IniRead function
; Syntax.........: _baseload_iniread($sSection, $sKey [, $sDefault = ""])
; Parameters ....: $sSection	- IniRead section
;				   $sKey		- IniRead key
;				   $sDefault	- IniRead default key value
; Return values .: Returns value as IniRead function
; ===============================================================================================================================
Func _baseload_iniread($sSection, $sKey, $sDefault = "")
	Return IniRead($file_config, $sSection, $sKey, $sDefault)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _update
; Description ...: Updates script listing
; Syntax.........: _update([$bLimpar = 0])
; Parameters ....: $bLimpar       	- [optional] cleans/defaults script listing
; Return values .: -
; ===============================================================================================================================
Func _update($limpar = 0)
	Local $tempsel = 0	; Temporary selection

	If $limpar = 1 Then
		$tempsel = _GUICtrlListBox_GetCurSel($gui_categoriaslist)
		_GUICtrlListBox_ResetContent($gui_categoriaslist)
	EndIf

	;MsgBox(0,"Debug 1", $tempsel)	; Temporary selection debug message
	$counter_bins = _FileCountLines($file_bins)
	If $counter_bins < 1 Then Msgbox(0,$lang_error_title, $lang_error_nobin)	; No binaries found


	$counter_categorias = _FileCountLines($file_categorias)
	;MsgBox(0,"Debug 2", $lang_gui_label3 & $counter_categorias)	; Categories count debug message
	If $counter_categorias < 1 Then Msgbox(0,$lang_error_title, $lang_error_nocat)	; No categories found

	Dim $binaries[$counter_bins][6], $categories[$counter_categorias][2]

	; Loop through categories file
	For $i = 0 To $counter_categorias - 1
		Local $temp
		$temp = StringSplit(FileReadLine($file_categorias,$i + 1),',',2)
		For $arrayi = 0 To UBound($temp) - 1
			$categories[$i][$arrayi] = $temp[$arrayi]
			;MsgBox(0,"Debug 3", $categories[$i][$arrayi]) ; Categories Loop debug message
		Next
	Next

	; Loop through binaries file
	For $i = 0 To $counter_bins - 1
		Local $temp
		$temp = StringSplit(FileReadLine($file_bins,$i + 1),',',2)
		For $arrayi = 0 To UBound($temp) - 1
			If $temp[$arrayi] = "nada" Then $temp[$arrayi] = ""
			If StringInStr($temp[$arrayi],"[;drive]") Then $temp[$arrayi] = StringReplace($temp[$arrayi],"[;drive]",@ScriptDir)
			$binaries[$i][$arrayi] = $temp[$arrayi]
			;MsgBox(0,"Debug 4",$binaries[$i][$arrayi]) ; Binaries Loop debug message
		Next
	Next


	;_GUICtrlListBox_BeginUpdate($gui_categoriaslist)
	For $i = 0 To UBound($categories) - 1
		_GUICtrlListBox_InsertString($gui_categoriaslist,$categories[$i][1],$i)
	Next

	_GUICtrlListBox_UpdateHScroll($gui_categoriaslist)

	If $limpar = 1 Then
		_GUICtrlListBox_SetCurSel($gui_categoriaslist, $tempsel)
	Else
		_GUICtrlListBox_SetCurSel($gui_categoriaslist, 0)
	EndIf

	;_GUICtrlListBox_EndUpdate($gui_categoriaslist)
	_GUICtrlListBox_ResetContent($gui_binlist)
	;_GUICtrlListBox_BeginUpdate($gui_binlist)
	;_GUICtrlListBox_InsertString($gui_binlist,$lang_gui_loading)
	;_GUICtrlListBox_EndUpdate($gui_binlist)
	;_GUICtrlListBox_ResetContent($gui_binlist)
	;_GUICtrlListBox_BeginUpdate($gui_binlist)
	$x = 0
	For $i = 0 To UBound($binaries) - 1
		;MsgBox(0,"Debug 5",$binaries[$i][2])
		If $binaries[$i][1] = _GUICtrlListBox_GetCurSel($gui_categoriaslist) + 1 Then
			$x += $x
			_GUICtrlListBox_InsertString($gui_binlist,$binaries[$i][2],$x)
			;MsgBox(0,"Debug 6",$binaries[$i][3])
			_GUICtrlListBox_SetItemData($gui_binlist, $x, $i)
		EndIf
	Next
	_GUICtrlListBox_UpdateHScroll($gui_binlist)
	;_GUICtrlListBox_EndUpdate($gui_binlist)
	_GUICtrlListBox_SetCurSel($gui_binlist, 0)

	If _GUICtrlListBox_GetCount($gui_categoriaslist) < 1 Then
		_GUICtrlListBox_InsertString($gui_categoriaslist,$lang_error_nocat)
	EndIf
	If _GUICtrlListBox_GetCount($gui_binlist) < 1 Then
		_GUICtrlListBox_InsertString($gui_binlist,$lang_error_nobin)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _launch
; Description ...: Launches the selected program
; Syntax.........: _launch()
; Parameters ....: -
; Return values .: -
; ===============================================================================================================================
Func _launch()
	Local $launch_item =  _GUICtrlListBox_GetItemData($gui_binlist, _GUICtrlListBox_GetCurSel($gui_binlist)), _
		  $launch_path = $binaries[$launch_item][3]

	;MsgBox(0,0,$launch_item & $binaries[$launch_item][5] & $binaries[$launch_item][4]) ; Debug path message

	ShellExecute($launch_path,$binaries[$launch_item][5],$binaries[$launch_item][4])
	If $config_clseonlnch <> 0 Then Exit

EndFunc