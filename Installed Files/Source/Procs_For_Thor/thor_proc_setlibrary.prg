Lparameters tcLibrary

Local lcFileUrl, lcLocalFilename, lcToolFolder, lcUrlFolder, llReturn

lcToolFolder  = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
lcLocalFilename = lcToolFolder + tcLibrary 
lcUrlFolder = 'http://foxpro.mattslay.com/Common/'
lcFileUrl = lcUrlFolder + tcLibrary  
llReturn = .t.

*-- Download the file if it is not present...
If !File(lcLocalFilename)
	llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', lcFileUrl, lcLocalFilename)
EndIf

If llReturn and File(lcLocalFilename)
	Set Library To (lcLocalFilename) Additive
Else
	llReturn = .f.
Endif

Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
Return llReturn
 