* Sets the date the last time CFU has been run today

Local lcTableName, lnSelect

lcTableName = _Screen.cThorFolder + 'Tables\LastCheckForUpdatesDate.DBF'

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
Replace LastDate With Date()

Use

Select(m.lnSelect)

