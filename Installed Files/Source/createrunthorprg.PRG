* Create the RunThor.PRG

#Include ThorVersion.h

Lparameters tcFolder

Local lcFolder, lcRunThor, loException

lcRunThor = GetPRGText(m.tcFolder)
lcFolder  = m.tcFolder + 'Thor\'

Try
	Erase (m.lcFolder + 'RunThor.PRG')
Catch To m.loException
Endtry

Try
	Strtofile (m.lcRunThor, m.lcFolder + 'RunThor.PRG')
Catch To m.loException
Endtry

Return



Procedure GetPRGText(tcFolder)
	Text To m.lcRunThor Noshow Textmerge
Lparameters tnInterval, tlInstallAllUpdates

* <<ccThorVersion>> 

Local lcFolder, lcTableName
lcFolder = '<<tcFolder>>'

If Not Empty (tnInterval) And 'N' = VarType (tnInterval) And tnInterval > 0
	lcTableName = m.lcFolder + 'Thor\Tables\LastCheckForUpdatesDate.DBF'
	Select 0
	If File (lcTableName)
		Use (lcTableName)
	Else
		Create Table (lcTableName) Free (LastDate D)
	Endif

	If Reccount() = 0
		Append Blank
	Endif

	Goto Top
	If Date() >= LastDate + tnInterval
		Replace LastDate With Date()
		Use

		Do m.lcFolder + 'Thor.APP' With 'Run', .T. && installs Thor, but without startups

		Execscript (_Screen.cThorDispatcher, 'Thor_Tool_Thor_CheckForUpdates', tlInstallAllUpdates)
	Else
		Use
	Endif

Endif	

lcFolder = '<<tcFolder>>'
Do m.lcFolder + 'Thor.APP' With 'Run', .F. && normal installation of Thor (with startups)

	Endtext

	Return m.lcRunThor
Endproc
