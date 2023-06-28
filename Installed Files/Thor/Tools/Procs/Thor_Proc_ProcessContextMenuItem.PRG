Lparameters lcToolName, llAlwaysShowHelp

Local lcDescription

If m.llAlwaysShowHelp = .F. And IsSpecialKey() = .F.
	Execscript(_Screen.cThorDispatcher, m.lcToolName)
Else
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_ToolContextMenu', m.lcToolName)
Endif

Endproc



* ================================================================================
* ================================================================================


Procedure IsSpecialKey

	* Returns .T. if either Shift or Control are pressed

	#Define VK_LBUTTON (0x01)	&& Left mouse button
	#Define VK_RBUTTON (0x02)	&& Right mouse button
	#Define VK_SHIFT   (0x10)	&& SHIFT key
	#Define VK_CONTROL (0x11)	&& CTRL key
	#Define VK_MENU	   (0x12)	&& ALT key

	#Define	VK_LBUTTON_DOWN		Bittest(GetKeyState(VK_LBUTTON), 31)
	#Define	VK_RBUTTON_DOWN		Bittest(GetKeyState(VK_RBUTTON), 31)
	#Define	VK_SHIFT_DOWN		Bittest(GetKeyState(VK_SHIFT), 31)
	#Define	VK_CONTROL_DOWN		Bittest(GetKeyState(VK_CONTROL), 31)
	#Define	VK_ALT_DOWN			Bittest(GetKeyState(VK_MENU), 31)

	Declare short GetKeyState In User32 Integer vKey

	Return VK_SHIFT_DOWN Or VK_CONTROL_DOWN

Endproc




