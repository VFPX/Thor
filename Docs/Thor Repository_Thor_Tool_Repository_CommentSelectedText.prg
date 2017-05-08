Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local laHandles[1], laLines[1], laObjectInfo[1], lcClipText, lcFirstLine, lcIndent, lcLine
Local lcNewCliptext, lcOldClipText, lcSourceFileName, lcThisFolder, lcWindowName, lcWonTop
Local llHasFocus, lnCursorPosition, lnI, lnLineCount, lnMatchIndex, lnWindowCount, loEditorWin
Local loThisForm, loWindow, loWindows
If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'Comment selected text'
		.Description = 'Puts a comment *!* before each line in the selected text, inserting beforehand a comment line with the date and leaves the cursor there for additional comments' ;
			+ Chr(13) + Chr(13) + 'Does a better job of handling the position of *!* when the selected text is indented.'

		* For public tools, such as PEM Editor, etc.
		.Source	  = 'Thor Repository'
		.Category = 'Misc.'
		.Author	  = 'Jim Nelson'
		.Link	  = 'http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20EditorWindow%20Object'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.    
lcThisFolder = Addbs (Justpath (Sys(16)))

****************************************************************
****************************************************************
* The next block of code gets the selected text from the code window
* and places it in the variable <lcClipText)

* make sure PEM Editor tools are available
Execscript (_Screen.cThorDispatcher, 'PEMEditor_StartIDETools')
* get the object which manages the editorwindow
* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20EditorWindow%20Object
loEditorWin = Execscript (_Screen.cThorDispatcher, 'class= editorwin from pemeditor')
* locate the active editor windows; exit if none active
If loEditorWin.FindWindow() <= 0
	Return
Endif

lcOldClipText = _Cliptext
* copy highlighted text into clipboard
loEditorWin.Copy()
lcClipText = _Cliptext
If Empty (lcClipText)
	Return
Endif

****************************************************************
****************************************************************
*  The code from here to the next comment block modifies the
*  text that had been highlighted (variable <lcCliptext>)
*  and creates the replacement text for it in (<lcNewCliptext>)
*
*  Note also the variable <lnCursorPosition> which is used
*  to indicate where the cursor is to be placed after
*  the replacement text is pasted in.

#Define ccTab  		Chr(9)
#Define ccCR		Chr(10)
#Define ccComment	'*!* '
lnLineCount	= Alines (laLines, lcClipText)
lcFirstLine	= laLines(1)
lcIndent	= Left (lcFirstLine, At (Getwordnum (lcFirstLine, 1), lcFirstLine) - 1)

lcNewCliptext	 = lcIndent + ccComment + '* Removed ' + Dtoc (Date()) + ' '
lnCursorPosition = loEditorWin.GetSelStart() + Len (lcNewCliptext)
For lnI = 1 To lnLineCount
	lcLine = laLines (lnI)
	Do Case
		Case Empty (lcLine)
			lcNewCliptext = lcNewCliptext + ccCR
		Case lcLine = lcIndent
			lcNewCliptext = lcNewCliptext + ccCR + lcIndent + ccComment + Substr (lcLine, 1 + Len (lcIndent))
		Otherwise
			lcNewCliptext = lcNewCliptext + ccCR + ccComment + lcLine
	Endcase
Endfor && lnI = 1 To lnLineCount

lcNewCliptext = lcNewCliptext + ccCR

****************************************************************
****************************************************************
* This final block of code pastes in the modification (in <lcNewCliptext>)
_Cliptext = lcNewCliptext
loEditorWin.Paste()
loEditorWin.SetInsertionPoint (lnCursorPosition)
_Cliptext = lcOldClipText

