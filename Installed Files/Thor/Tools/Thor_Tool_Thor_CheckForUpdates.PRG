Lparameters tlInstallAllUpdates

If Vartype (tlInstallAllUpdates) # 'L'
	Return
Endif

* default, does nothing, but customizable ... see https://github.com/VFPX/Thor/issues/96
Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Before_Check_For_Updates')

* the real work horse
Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Check_For_Updates')

* default, does nothing, but customizable ... see https://github.com/VFPX/Thor/issues/96
Execscript (_Screen.cThorDispatcher, 'Thor_Proc_After_Check_For_Updates')
