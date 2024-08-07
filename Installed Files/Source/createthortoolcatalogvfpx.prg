Lparameters tcSources, tlStyle

Local laTools[1], lcCategory, lcCategoryHeader, lcCategoryStyle, lcDescription, lcFilename, lcHtml
Local lcLink, lcPreviousCategory, lcSources, lcSubCat, lcTableCellStyle, lcTableHeaderStyle
Local lcTableStyle, lcTool, lcToolFolder, lcToolName, lcVideoLink, lcVideoTime, lcVideoUrl
Local lnCategoryCount, lnCount, lnPos, lnX, loThor, loTool, loTools
Local x

If Empty (tcSources)
	lcSources = ''
Else
	lcSources = Upper ('|' + Chrtran (tcSources, ',;', '||') + '|')
Endif

lcToolFolder = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
loThor		 = Execscript (_Screen.cThorDispatcher, 'Thor Engine=')
loTools		 = loThor.GetToolsCollection (lcToolFolder)

Dimension laTools (loTools.Count, 2)
lnX = 1

For Each loTool In loTools
	laTools[lnX, 1] = loTool.internalsort
	laTools[lnX, 2] = loTool
	lnX = lnX + 1
Endfor

= Asort (laTools)

lcPreviousCategory = 'XXXXXXXXXX'
lcHtml			   = ''
lnCategoryCount	   = 0

*--- Define CSS Styles ---------------------------------

Text To lcCategoryStyle Noshow Pretext 15
Endtext

Text To lcTableStyle Noshow Pretext 15
		border-width: 0px;
		border-spacing: 0px;
		border-style: solid;
		border-color: white;
		border-collapse: collapse;
		background-color: white;
		margin-top: -1px;
Endtext

Text To lcTableHeaderStyle Noshow Pretext 15
		border-width: 0px;
		padding: 1px;
		border-style: inset;
		border-color: gray;
		background-color: white;
Endtext

Text To lcTableCellStyle Noshow Pretext 15
		border-width: 1px;
		padding: 2px;
		border-style: solid;
		border-color: #E2E2E2;
		background-color: white;
		vertical-align: top; 
Endtext

lnCount = 0

lcToolFolder  = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')

For x = 1 To loTools.Count

	loTool	   = laTools[x, 2]

	If Upper (lcToolFolder) == Upper (Addbs (Justpath (loTool.FullFilename))) and;
		(Empty (lcSources) Or (Upper ('|' + loTool.Source + '|') $ lcSources))
		
		lcCategory = Getwordnum (Evl(loTool.Category, loTool), 1, '|')
		If Upper(lcCategory) == Upper('Applications')
			Loop
		EndIf 
			
		lnPos	   = Atc ('|', loTool.Category)

		If lnPos = 0
			lcSubCat = ''
		Else
			lcSubCat = Substr (loTool.Category, lnPos + 1)
		Endif

		*!* * Removed 2/11/2012 
		*!* lcToolName = '<b>' + loTool.Prompt + '</b>'
		lcToolName = loTool.Prompt 

		*===== Category section ================================
		If lcCategory # lcPreviousCategory

			If lnCategoryCount > 0
				lcHtml = lcHtml + '</table>'
			Endif

			Text To lcCategoryHeader Noshow Textmerge
			<div style="<<lcCategoryStyle>>">
				Category: <<lcCategory>>
			</div>
			Endtext

			*!* * Removed 2/12/2012 
			*!* lcHtml = lcHtml + Iif (lnCategoryCount > 0, '<p>&nbsp;</p>', '')
			lcHtml = lcHtml + lcCategoryHeader

			lcPreviousCategory = lcCategory
			lnCategoryCount	   = lnCategoryCount + 1

			*-- Start a new table for the tools in this Category.
			lcHtml = lcHtml + '<table style="' + lcTableStyle + '">'
			
			lcPreviousSubCat = ''

		EndIf
		
		If Not lcSubCat == lcPreviousSubCat
			Text To lcTool Noshow Textmerge
			<tr>
				<td style="<<lcTableCellStyle>>" colspan=2>
					<<lcSubCat>>
				</td>
			</tr>
			Endtext

			lcHtml	= lcHtml + lcTool
			lcPreviousSubCat = lcSubCat
		EndIf 

		*======== Tools within each Category
		lcDescription = Strtran (loTool.Description, Chr(13), '<br />')

		*!* * Removed 2/11/2012 
		*!* lcFilename	= '<br />' + 'Filename: ' + Justfname (loTool.FullFilename)
		*!* lcLink		= Iif (Not Empty (loTool.Link), '<br />Link: <a href="' + loTool.Link + '">Tool home page</a>', '')
		*!* lcVideoUrl	= Getwordnum (loTool.videolink, 1, '|')
		*!* lcVideoTime	= Getwordnum (loTool.videolink, 2, '|')
		*!* lcVideoLink	= Iif (Not Empty (loTool.videolink), '<br />Video: <a href="' + lcVideoUrl + '">Watch video</a>', '')
		*!* If Not Empty (lcVideoTime)
		*!* 	lcVideoLink = lcVideoLink + '&nbsp;&nbsp;&nbsp;(' + lcVideoTime + ')'
		*!* Endif

		*!* lcDescription = lcDescription + '<br /><br />Source: ' + loTool.Source
		*!* If Not Empty (loTool.Link)
		*!* 	lcDescription = lcDescription + '&nbsp;&nbsp;&nbsp;&nbsp;<a href="' + loTool.Link + '">Tool home page</a>'
		*!* Endif
		*!* If Not Empty (loTool.videolink)
		*!* 	lcVideoUrl	  = Getwordnum (loTool.videolink, 1, '|')
		*!* 	lcVideoTime	  = Getwordnum (loTool.videolink, 2, '|')
		*!* 	lcDescription = lcDescription + '&nbsp;&nbsp;&nbsp;&nbsp;<a href="' + lcVideoUrl + '">Watch Video</a>'
		*!* 	If Not Empty (lcVideoTime)
		*!* 		lcDescription = lcDescription + '&nbsp;&nbsp;(' + lcVideoTime + ')'
		*!* 	Endif
		*!* Endif

		Text To lcTool Noshow Textmerge
		<tr>
			<td style="<<lcTableCellStyle>> width:200px;">
				<<lcToolName>>
			</td>
			<td style="<<lcTableCellStyle>> width:600px;">
				<<lcDescription>>
			</td>
		</tr>
		Endtext

		lcHtml	= lcHtml + lcTool
		lnCount	= lnCount + 1

	Endif

Endfor

Wait lnCount Window Nowait
Return lcHtml
