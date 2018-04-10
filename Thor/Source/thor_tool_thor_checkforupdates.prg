Lparameters tlInstallAllUpdates

If Vartype (tlInstallAllUpdates) # 'L'
	Return
Endif

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Check_For_Updates')
