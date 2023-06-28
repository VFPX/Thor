Lparameters toUpdateInfo

*-- Get the available version from the cloud. (2011-11-07 M. Slay - Revised to pass in UpdateInfo object
toUpdateInfo = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetAvailableVersionInfo', toUpdateInfo)

Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo) 
Return toUpdateInfo  