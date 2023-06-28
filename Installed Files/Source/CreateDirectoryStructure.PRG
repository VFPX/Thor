* Create the Thor directory structure if it doesn't already exist.

Lparameters tcFolder

#include Thor_UI.H

CreateThorFolder(m.tcFolder + 'Thor')
CreateThorFolder(m.tcFolder + 'Thor\Tables')
CreateThorFolder(m.tcFolder + 'Thor\Tools')
CreateThorFolder(m.tcFolder + 'Thor\Tools\Samples')
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccMyTools)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccMySettings)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccProcs)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccUpdates)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccUpdates + '\My Updates')
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccUpdates + '\Never Update')
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccUpdates + '\Removed')
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccApps)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccComponents)
CreateThorFolder(m.tcFolder + 'Thor\Tools\' + ccMyTemplates)


Procedure CreateThorFolder(tcFolder)
	If Not Directory (m.tcFolder)
		Md (m.tcFolder)
	Endif
Endproc


