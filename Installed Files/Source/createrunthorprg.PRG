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

	* ================================================================================
	* ================================================================================ 
	Text To m.lcRunThor Noshow Textmerge
Lparameters tnInterval, tlInstallAllUpdates

* <<ccThorVersion>> 

#Define	ccThorHomeFolder '<<tcFolder>>'

Local lcTableName, ldLastRunDate, lnSelect

If Not Empty (m.tnInterval) And 'N' = Vartype (m.tnInterval) And m.tnInterval > 0

	* ================================================================================
	lcTableName = ccThorHomeFolder + 'Thor\Tables\LastCheckForUpdatesDate.DBF'

	lnSelect = Select()
	Select 0
	If File (m.lcTableName)
		Use (m.lcTableName) Shared Again
	Else
		Create Table (m.lcTableName) Free (LastDate D)
	Endif

	If Reccount() = 0
		Append Blank
	Endif

	Goto Top
	ldLastRunDate = LastDate
	Use

	Select(m.lnSelect)
	* ================================================================================

	If Date() >= m.ldLastRunDate + m.tnInterval
		Do ccThorHomeFolder  + 'Thor.APP' With 'Run', .T. && installs Thor, but without startups
		Execscript (_Screen.cThorDispatcher, 'Thor_Tool_Thor_CheckForUpdates', m.tlInstallAllUpdates)
	Endif
Endif

Do ccThorHomeFolder  + 'Thor.APP' With 'Run', .F. && normal installation of Thor (with startups)

Return

	EndText
* ================================================================================ 
* ================================================================================ 

	Return m.lcRunThor
Endproc
