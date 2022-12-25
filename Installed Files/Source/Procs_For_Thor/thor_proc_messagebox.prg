#Define cnMessageBoxTimeout    3000

Lparameters tcMessageBoxText, tnDialogBoxType, tcTitleBarText
Local lnMessageBoxTimeout, lnResult

If Pemstatus(_Screen, 'nThorCFUMessageBoxTimeout', 5)
	lnMessageBoxTimeout = _Screen.nThorCFUMessageBoxTimeout
Else
	lnMessageBoxTimeout = cnMessageBoxTimeout
Endif

lnResult = Messagebox (tcMessageBoxText, tnDialogBoxType, tcTitleBarText, lnMessageBoxTimeout)

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult
