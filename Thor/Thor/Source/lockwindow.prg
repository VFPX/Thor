* From Doug Hennig's Win32API session at SW Fox 2012

Lparameters tlLock,			;
	tnHWnd
Local lnHWnd
Declare Integer LockWindowUpdate In Win32API		;
	Integer nHandle
Do Case
	Case Not tlLock
		lnHWnd = 0
	Case Pcount() = 1
		Declare Integer GetDesktopWindow In Win32API
		lnHWnd = GetDesktopWindow()
	Otherwise
		lnHWnd = tnHWnd
Endcase
LockWindowUpdate(lnHWnd)
Return