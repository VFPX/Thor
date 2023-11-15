*  Alternative to MESSAGEBOX
Parameters tcPrompt, tcCaptions, tcTitleCaption, tnTimerDelay, tcPromptFontSize, tcButtonFontSize, llTopLevelForm, lnBackColor, tnMaxVisiblePromptLines

*	tcPrompt			Character prompt, may contain CRLF or "|" as line delimiters
*	tcCaptions			Captions for buttons, separated by ';'.  For each caption:
*								If first character is "|", then this button gets original focus
*								If it contains "==", characters following are the value of the result
*									(may be character).
* 			if contains "^^", characters following are the tool tip
*	tcTitleCaption		Caption for the form
*  	tnTimerDelay		Delay, in seconds, before cancelling (returns zero)
*	tcPromptFontSize	Font size used for the prompt
*	tcButtonFontSize	Font size used for all the buttons
*	llTopLevelForm		Within top level form?
*   lnBackColor			Back Color (Dodger Blue)

*  Result: (gnReturnValue)
*		Normally, the number of the button clicked. However, if "==" was used in the
*		caption of the button, then the result is the value of whatever characters follow the "==".

*  Sample:
*  	AlertMsg("This is the prompt|on two lines", "Yes=='Y';No=='N'", "Sample title")

#Define DefaultCaptions 	 	'^OK'
#Define DefaultTitleCaption		'FYI'
#Define DefaultPromptFontSize	11
#Define DefaultButtonFontSize 	10
#Define SimpleWhite				Rgb(255, 255, 255)
#Define CR						Chr[13]

Local laCaptions[1], lcCaption, lcFocus, lcHeight, lcLeft, lcName, lcPrompt, lnButtons, lnHeight
Local lnI, lnIncr, lnLeft, lnLeftIncr, lnMaxHeight, lnMaxWidth, lnPos, lnTop, lnValue, lnWidth
Local loCallingForm
Local _AlertMsgForm

tnMaxVisiblePromptLines = Evl (m.tnMaxVisiblePromptLines, 20)

Private gnReturnValue

Do Case

	Case m.llTopLevelForm
		loCallingForm = GetTopLevelForm()
		_AlertMsgForm = Createobject('TempForm')

	Case 'O' = Type('_screen.ActiveForm') And _Screen.ActiveForm.Height > 100 + Sysmetric(9)
		loCallingForm = _Screen.ActiveForm
		_AlertMsgForm = Createobject('TempForm')

	Otherwise
		loCallingForm = ''
		_AlertMsgForm = Createobject('TempFormDeskTop')

Endcase


gnReturnValue = 0
lcPrompt	  = Chrtran(m.tcPrompt, '|', Chr(13))
lcPrompt	  = Strtran(m.lcPrompt, Chr(13), Chr(13) + Chr(10))

If 'N' = Vartype(m.tcCaptions)
	Do Case
		Case 0 = m.tcCaptions % 16
			tcCaptions = '^OK' && OK, cancel allowed
		Case 3 = m.tcCaptions % 16
			tcCaptions = "|Yes=='Y';No=='N';^Cancel=='C'" && yes (default) / no / cancel
		Case 4 = m.tcCaptions % 16
			tcCaptions = "|Yes=='Y';^No=='N'" && yes (default) / no
		Case 13 = m.tcCaptions % 16
			tcCaptions = "Yes=='Y';|No=='N';^Cancel=='C'" && yes / no (default) / cancel
		Case 14 = m.tcCaptions % 16
			tcCaptions = "Yes=='Y';|^No=='N'" && yes / no (default)
	Endcase
Endif

With m._AlertMsgForm
	.WindowType	= 1		&& modal
	.Height		= 36
	.Width		= 134 	&& apparently, the minimum!
	.Name		= 'AlertMsg'
	.BackColor	= Evl( m.lnBackColor, SimpleWhite)
	.TitleBar	= 1
	.MinButton	= .F.
	.MaxButton	= .F.
	.Closable	= .F.
	.Caption	= Evl(m.tcTitleCaption, DefaultTitleCaption)
	.FontSize	= Evl(m.tcPromptFontSize, DefaultPromptFontSize)

	.AddObject('edtPrompt', 'EditBox')
	With .edtPrompt
		.ReadOnly		   = .T.
		.TabStop		   = .F.
		.DisabledForeColor = Rgb(0, 0, 0)
		.DisabledBackColor = Evl( m.lnBackColor, SimpleWhite)
		.Left			   = 20
		.Top			   = 10
		.Width			   = 20
		.BackStyle		   = 0
		.BorderStyle	   = 0
		.Value			   = m.lcPrompt
		.Height			   = 10 + .Parent.TextHeight(m.lcPrompt)
		.Width			   = 6 + .Parent.TextWidth(m.lcPrompt) + Sysmetric(5)
		.FontSize		   = Evl(m.tcPromptFontSize, DefaultPromptFontSize)
		.Visible		   = .T.

		* determine the max height and width we'll allow for the editbox
		lnMaxHeight = 10 + .Parent.TextHeight(Replicate(Chr(13) + Chr(10), m.tnMaxVisiblePromptLines - 1))
		If .Parent.ShowWindow = 0 Or 'O' # Vartype(m.loCallingForm)
			lnMaxWidth = Min(1200, .75 * _Screen.Width)
		Else
			lnMaxWidth = m.loCallingForm.Width - 48
			*!*	For Each loForm In _Screen.Forms
			*!*		If loForm.ShowWindow = 2
			*!*			lnMaxWidth = loForm.Width - 48
			*!*		Endif
			*!*	Endfor
		Endif
		lnMaxWidth = Min(1000, m.lnMaxWidth)

		* check width
		If .Width <= m.lnMaxWidth
			.ScrollBars = 0
		Else
			.ScrollBars	= 2
			.Width		= m.lnMaxWidth
		Endif

		* check height
		If .Height > m.lnMaxHeight
			.ScrollBars	= 2
			.Height		= m.lnMaxHeight
		Endif

	Endwith

	* Current height (excluding room for buttons)
	lcHeight = .edtPrompt.Top + .edtPrompt.Height + 16
	* Left margin for next button added
	lcLeft = 20

	* Create list of captions
	lnButtons = Alines(laCaptions, Evl(m.tcCaptions, DefaultCaptions), ';')
	* Which item gets focus (defaults to first)
	lcFocus   = .F.
	For lnI = 1 To m.lnButtons
		lcName = 'Btn' + Transform(m.lnI)
		.AddObject(m.lcName, 'TempButton')
		With .&lcName
			* process caption
			lcCaption = m.laCaptions(m.lnI)

			* if contains "^^", characters following are the tool tip
			lnPos = At('^^', m.lcCaption)
			If m.lnPos # 0
				._Tooltip			 = Substr( m.lcCaption, m.lnPos + 2)
				._ToolTipOrientation = 'BALR14'
				lcCaption			 = Left( m.lcCaption, m.lnPos - 1)
			Endif

			* if contains "==", characters following are the value of the result (may be character)
			lnPos = At('==', m.lcCaption)
			If m.lnPos = 0
				.ButtonNumber = m.lnI
			Else
				Try
					lnValue = Evaluate(Substr(m.lcCaption, m.lnPos + 2))
				Catch

				Endtry
				.ButtonNumber = Evl(m.lnValue, m.lnI)
				lcCaption	  = Left(m.lcCaption, m.lnPos - 1)
			Endif

			* if contains "|", remember this as the one to SetFocus
			If '|' $ m.lcCaption
				lcCaption = Strtran(m.lcCaption, '|', '')
				lcFocus	  = m.lcName
			Endif

			* if contains "^", then Escape / closable allowed
			If '^' $ m.lcCaption
				lcCaption		 = Strtran(m.lcCaption, '^', '')
				.Parent.Closable = .T.
				gnReturnValue	 = .ButtonNumber
			Endif

			.Caption  = '\<' + m.lcCaption
			.FontSize = Evl(m.tcButtonFontSize, DefaultButtonFontSize)
			.Top	  = m.lcHeight
			.Left	  = m.lcLeft
			.Visible  = .T.

			* Determine position of start of next button, if any (space between them = 12)
			lcLeft = m.lcLeft + .Width + 12
		Endwith
	Endfor

	* Compute the actual height of the form, including room for buttons
	.Height = m.lcHeight + .Btn1.Height + 10
	* Necessary width, if the Prompt is wider than buttons
	.Width  = .edtPrompt.Width + 40

	If .Width <= m.lcLeft + 8 && Buttons already wider than the prompt?
		.Width = m.lcLeft + 8
	Else && if not, widen the buttons and spacing between them
		lnIncr = Floor((.Width - (m.lcLeft + 8)) / m.lnButtons)
		If 1 = m.lnButtons
			lcName = 'Btn1'
			With .&lcName
				.Left = .Left + m.lnIncr / 2
			Endwith
		Else
			lnLeftIncr = m.lnIncr / 4
			For lnI = 1 To m.lnButtons
				lcName = 'Btn' + Transform(m.lnI)
				With .&lcName
					.AutoSize  = .F.
					.Width	   = .Width + m.lnIncr / 2
					.Left	   = .Left  + m.lnLeftIncr
					lnLeftIncr = m.lnLeftIncr + m.lnIncr
				Endwith
			Endfor
		Endif
	Endif

	* center the Prompt (occurs if small prompt, many labels)
	.edtPrompt.Left = (.Width - .edtPrompt.Width) / 2

	* Timer needed?
	If Not Empty(m.tnTimerDelay)
		.AddObject('Timer', 'TempTimer', m.tnTimerDelay)
	Endif

	* set the focus
	If Not Empty(m.lcFocus)
		.&lcFocus..SetFocus
	Endif

	* position the form
	If 'C' = Vartype(m.loCallingForm) Or Isnull(m.loCallingForm)
		.AutoCenter = .T.
	Else
		lnTop	 = m.loCallingForm.Top
		lnLeft	 = m.loCallingForm.Left
		lnHeight = m.loCallingForm.Height
		lnWidth	 = m.loCallingForm.Width

		If m.loCallingForm.ShowWindow = 2
			.Top  = (m.lnHeight / 2 ) - ((Sysmetric(9) + .Height) / 2)
			.Left = (m.lnWidth / 2 ) - (.Width / 2)
		Else
			*** SWH 2022-11-29 : need to do the same for Top - sometimes windows evaluate to a negative number (generally off the screen)
			.Top  = Iif(m.lnTop < 0, 0, m.lnTop) + (m.lnHeight / 2 ) - ((Sysmetric(9) + .Height) / 2)
			*** SWH 2022-04-21 : my weird setup shows -1920 and I can never see the window!
			.Left = Iif(m.lnLeft < 0, 0, m.lnLeft) + (m.lnWidth / 2 ) - (.Width / 2)
		Endif
	Endif

Endwith

m._AlertMsgForm.Show(1)

Return Execscript (_Screen.cThorDispatcher, 'Result=', m.gnReturnValue)


* ================================================================================
* ================================================================================


Define Class TempForm As Form
	ShowWindow = 1
	Top		   = -1000
	Left	   = -1000

	Procedure Activate

	Endproc

	Procedure Unload

	Endproc

Enddefine


Define Class TempFormDeskTop As Form
	Desktop	   = .T.
	ShowWindow = 1
	Top		   = -1000
	Left	   = -1000

	Procedure Activate

	Endproc

	Procedure Unload

	Endproc

Enddefine


Define Class TempButton As CommandButton 
	AutoSize	 = .T.
	ButtonNumber = 0

	Procedure Click
		*:Local gnReturnValue
		gnReturnValue = This.ButtonNumber
		Thisform.Release
	Endproc

	Procedure KeyPress
		Lparameters nKeyCode, nShiftAltCtrl
		*:Local gnReturnValue
		If m.nKeyCode = 27 And Thisform.Closable
			Thisform.Release
		Endif
	Endproc

	Procedure MouseEnter(nButton, nShift, nXCoord, nYCoord)
		* to avoid default behavior
	Endproc

	Procedure MouseLeave(nButton, nShift, nXCoord, nYCoord)
		* to avoid default behavior
	Endproc

Enddefine


Define Class TempTimer As Timer
	Interval = 1000000

	Procedure Init(lnInterval)
		If m.lnInterval > 3600 And 0 = m.lnInterval % 1000 && milli-seconds
			This.Interval = m.lnInterval
		Else
			This.Interval = 1000 * m.lnInterval && seconds
		Endif
	Endproc

	Procedure Timer
		Thisform.Release
	Endproc
EndDefine


Procedure GetTopLevelForm
	* From Foundation Classes '_ui.vcx'

	Local loTopForm, loForm
	Assert Type('_SCREEN.ActiveForm') # 'O'  Or			;
		Inlist(_Screen.ActiveForm.ShowWindow, 0, 1, 2)

	Do Case
		Case _Screen.FormCount = 0 Or						;
				(Type('_SCREEN.ActiveForm') = 'O' And		;
				  _Screen.ActiveForm.ShowWindow = 0 )     && ShowWindow In Screen

			loTopForm = _Screen

		Case(Type('_SCREEN.ActiveForm') = 'O' And		;
				  _Screen.ActiveForm.ShowWindow = 2 )    && ShowWindow As Top Form

			loTopForm = _Screen.ActiveForm

		Otherwise

			For Each loForm In _Screen.Forms  && note: these may be toolbars
				&& if undocked, but that's okay --
				&& they are only ShowWIndow 0 or 1.

				If loForm.ShowWindow = 2 && the first one in the collection will
					&& be "active top form"
					loTopForm = loForm
					Exit
				Endif
			Endfor

			If Vartype(loTopForm) # 'O'
				loTopForm = _Screen
			Endif

	Endcase

	Return loTopForm

Endproc

