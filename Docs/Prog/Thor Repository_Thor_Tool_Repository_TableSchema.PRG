 
Lparameters lxParam1
 
****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.
 
If Pcount() = 1                              ;
          And 'O' = Vartype (lxParam1)  ;
          And 'thorinfo' = Lower (lxParam1.Class)
 
     With lxParam1
     
          * Required
          .Prompt        = 'Schema' && used when tool appears in a menu
          .Description   = "Print/View the current table's schema" && may be lengthy, including CRs, etc
          
          * Optional
          .StatusBarText = .Description
          .Summary       = '' && if empty, first line of .Description is used
          
          * For public tools, such as PEM Editor, etc.
          .Source        = 'Thor Repository' && e.g., 'PEM Editor'
          .Category      = 'Tables'
          .Author        = 'Eric Selje'
          .Version       = '1.2 June 4, 2011' 
          .Link          = 'www.saltydogllc.com'
     Endwith
 
     Return lxParam1
Endif
 
****************************************************************
****************************************************************
* Normal processing for this tool begins here.    
****************************************************************
*  Following two lines make sure PEM Editor IDE Tools are running
*  and then get the highlighted text, and try to open the file
*  See also PEME_OpenTable.PRG
* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20Tools%20Object
loTools = Execscript (_Screen.cThorDispatcher, 'class= tools from pemeditor')
loTools.UseHighlightedTable (Set ('Datasession'))
****************************************************************

If Empty (Alias())
	WAIT WINDOW "No table selected." TIMEOUT 2
Else
	oSchemaGenerator=CREATEOBJECT("Schema")
	oSchemaGenerator.cTable = DBF()
	IF oSchemaGenerator.GenerateSchema()	
		oSchemaGenerator.showSchema()
	ENDIF
Endif


DEFINE CLASS Schema AS Custom OLEPUBLIC

cAlias = ""
cTable = ""
cFileName = ""
cSchemaFile = ""
nSele = 0
lView = .f.
cCaption = ""

PROCEDURE Init
	This.nSele = SELECT()
ENDPROC

PROCEDURE Destroy
SET TEXTMERGE TO 
USE IN SELE("crsSchema")
IF FILE(This.cSchemaFile)
	ERASE (This.cSchemaFile)
	SELECT (This.nSele)
ENDIF 
ENDPROC


PROCEDURE Error(nError, cMethod, nLine)
WAIT WINDOW "Error " + TRANSFORM(nError) + " in line " + TRANSFORM(nLine)+" of " + cMethod + CHR(13) + MESSAGE(1)
ENDPROC

PROCEDURE cTable_Assign
LPARAMETERS cTable

This.cTable = cTable
This.cAlias = ALIAS()
This.cFileName = ADDBS(SYS(2023))+This.cAlias+".html"
IF FILE(This.cFileName)
	* Overwrite it
	cSafety = SET("SAFETY")
	SET SAFETY OFF
	ERASE (This.cFileName)
	SET SAFETY &cSafety
ENDIF
This.cSchemaFile = ADDBS(SYS(2023))+SYS(2015)+".dbf"
nSourceType = CURSORGETPROP("SourceType",This.cAlias)
This.lView = nSourceType <3
IF This.lView
	This.cCaption = IIF(nSourceType=1,"Local","Remote")+" View: " + This.cAlias
ELSE
	This.cCaption = This.cTable
ENDIF 
COPY STRUCTURE EXTENDED TO (This.cSchemaFile)
USE IN SELE("crsSchema")
USE (This.cSchemaFile) IN 0 ALIAS crsSchema

RETURN .t.


PROCEDURE GenerateSchema
LOCAL lReturn
LOCAL X, cAttributes, cCaption, cComment, cConnString, cConnection, cDataType
LOCAL cDataType2, cDefault, cField, cFormat, cInputMask, cValidation, iDbObjects, iTags, lDBC, y
lReturn = NOT EMPTY(This.cTable)
lDBC = not EMPTY(DBC()) and INDBC(This.cAlias,"TABLE")
IF lReturn
	SET TEXTMERGE TO (This.cFileName) 
	SET TEXTMERGE DELIMITERS TO <<,>>
	TEXT TEXTMERGE NOSHOW 
	<html>
	<head>
	 <style>
	<<IIF(FILE("Schema.css"),FILETOSTR("Schema.css"),This.getCSS())>>
	 </style>
	 <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
	<script>$(document).ready(function(){
	   $("tr:even").css("background-color", "#F4F4A8");
	   $("tr:odd").css("background-color", "#EFF1D1");});
	</script>

	</head>
	<body>
	<h1><<This.cCaption>></h1>
	<table id='tblHeader'>
	<tr><th>Alias</th><th>Database</th><th>Last Updated</th><th>Code Page</th><th>Records</th><th>Fields</th></tr>
	<tr><td><<ALIAS()>></td><td><<EVL(DBC(),'(Free Table)')>></td><td><<LUPDATE()>></td><td><<CPDBF()>></td><td><<TRANSFORM(RECCOUNT(),'999,999,999')>></td><td><<TRANSFORM(FCOUNT(),'99,999')>></td></tr>
	ENDTEXT

	SET TEXTMERGE ON NOSHOW

	IF This.lView
		\ <h4>View's Properties</h4>
		cConnection = DBGETPROP(This.cAlias,"VIEW","ConnectName") 
		cConnString = DBGETPROP(cConnection,"CONNECTION","ConnectString")

		\ <table id='tblView'>
		\ <tr><th>Connection Name</th><td><<cConnection>>&nbsp;[<<cConnString>>] </td></tr>
		\ <tr><th>Parameters</th><td><<This.vp("Parameterlist") >></td></tr>
		\ <tr><th>Tables</th><td><<This.vp("Tables")>> </td></tr>
		\ <tr><th>Comment</th><td><<<<This.vp("Comment") >></td></tr>
		\ <tr><th>SQL</th><td><<This.vp("SQL")>></td></tr>
		\ <tr><th>Properties</th><td>
		\ <table id='tblViewProps'>
		\ <tr><th>Send Updates</th><td><<This.vp("SendUpdates")>></td><th>Compare Memo</th><td> <<This.vp("CompareMemo")>></td><th>Fetch Size</th><td><<This.vp("FetchSize")>></td><th>Use Memo Size</th><td><<This.vp("UseMemoSize")>></td></tr>
		\ <tr><th>Update Type</th><td><<This.vp("UpdateType")>></td><th>Fetch as Needed</th><td> <<This.vp("FetchAsNeeded")>></td><th>Max Records</th><td><<This.vp("MaxRecords")>></td><th>Where Type</th><td><<This.vp("WhereType")>></td></tr>
		\ <tr><th>Batch Update Cnt</th><td><<This.vp("BatchUpdateCount")>></td><th>Fetch Memo</th><td><<This.vp("FetchMemo")>> </td><th>Prepared</th><td><<This.vp("Prepared")>></td><th>Offline?</th><td><<This.vp("Offline")>></td></tr>
		\ </table>
		\ </td></table>		
	ENDIF 

	\ <h4>Structure:</h4><table>	
	\ <table id='tblSchema'>
	IF This.lView
		\ <tr><th>Field Name</th> <th>Data Type</th> <th>Attributes</th> <th>Default</th><th>Upd</th><th>UpdateName</th> <th></th><th></th></tr>
	ELSE
		\ <tr><th>Field Name</th> <th>Data Type</th> <th>Attributes</th> <th>Default</th><th>Format</th><th>InputMask</th> <th>Validation</th><th>Comment</th></tr>
	ENDIF 
	SELECT crsSchema
	SCAN
		cField = This.cAlias+'.'+field_name
		IF This.lView
			STORE "" TO cCaption, cAttributes, cDefault, cComment, cFormat, cInputMask, cValidation 
			cFormat = IIF(DBGETPROP(cField,"FIELD","Updatable"),"Yes","")
			cInputMask = DBGETPROP(cField,"FIELD","UpdateName")
			cCaption = IIF(DBGETPROP(cField,"FIELD","KeyField"),"(Key)","")
			cDefault = DBGETPROP(cField,"FIELD","DefaultValue")
			cDataType = This.getField()
			cDataType2 = DBGETPROP(cField,"FIELD","DataType")
			IF cDataType != cDataType2
				cDataType = cDataType + ' << ' + cDataType2
			ENDIF
			
		ELSE
			cCaption = IIF(lDBC,DBGETPROP(cField,"FIELD","Caption"),"")
			cCaption = IIF(EMPTY(cCaption),""," ("+cCaption+")")
			cAttributes = This.getAttributes()
			cDefault = IIF(lDBC,DBGETPROP(cField,"FIELD","Default"),"")
			cComment = IIF(lDBC,DBGETPROP(cField,"FIELD","Comment"),"")
			cFormat = IIF(lDBC,DBGETPROP(cField,"FIELD","Format"),"")
			cInputMask = IIF(lDBC,DBGETPROP(cField,"FIELD","InputMask"),"")
			cValidation = IIF(lDBC,DBGETPROP(cField,"FIELD","RuleExpression"),"")
			cDataType = This.getField()
		ENDIF
				
		\<tr> <td> <<field_name>> <<cCaption>> </td>
		\\<td><<cDataType>> </td>
		\\<td> <<cAttributes>> </td>
		\\<td> <<cDefault>> </td>
		\\<td> <<cFormat>> </td>
		\\<td> <<cInputMask>> </td>
		\\<td> <<cValidation>> </td>

		\\<td> <<cComment >> </td>
	ENDSCAN
	\</table>
	IF lDBC AND NOT This.lView
		\ <h4>Table Properties:</h4><table>
		This.writeTableProperty("PrimaryKey")
		This.writeTableProperty("RuleExpression")
		This.writeTableProperty("RuleText")
		This.writeTableProperty("InsertTrigger")
		This.writeTableProperty("UpdateTrigger")
		This.writeTableProperty("DeleteTrigger")
		This.writeTableProperty("Comment")
		\</table>
		iDbObjects = ADBOBJECTS(aDb,"RELATION")
		IF ASCAN(aDb,UPPER(This.cAlias))>0
		\ <h4>Relations:</h4><table>		
		\ <tr><th>Table</th><th>Field</th><th>Related to</th><th>On</th></tr>
		FOR X = 1 TO iDbObjects
			IF aDb[X,1]=UPPER(This.cAlias) OR aDb[X,3]=UPPER(This.cAlias)
				\<tr> <td> <<aDb[X,1]>> </td><td><<aDb[X,2]>> </td><td><<aDb[X,3]>> </td><td><<aDb[X,4]>> </td></tr>
			ENDIF
		NEXT
		ENDIF
		\ </table>		
	ENDIF
	* Indexes
	SELECT (This.cAlias)
	IF NOT This.lView
		DIMENSION aTags[1]
		iTags = ATAGINFO(aTags)
		IF iTags = 0
			\ No Structural Index Tags
		ELSE
			\ <h4>Indexes:</h4><table>

			\ <table id='tblIndices'><tr><th>Tag Name</th> <th>Type</th> <th>Expression</th> <th>Filter</th> <th>Order</th> <th>Collation</th></tr>
			FOR X = 1 TO iTags
			\<tr>
				FOR y = 1 TO 6 
					\ <td> <<aTags[X,Y]>>	</td>
				NEXT
			\</tr>
			NEXT
		ENDIF 	
		\</table>
	ENDIF

	* Dependencies
	\ <h4>Dependencies:</h4><table>

	\ </body>	
	SET TEXTMERGE OFF
	SET TEXTMERGE TO 
ENDIF
RETURN lReturn

FUNCTION vp
LPARAMETERS cProperty
LOCAL cValue
cValue = DBGETPROP(This.cAlias,"View",cProperty) 
IF VARTYPE(cValue)='L'
	cValue=IIF(cValue,'Yes','No')
ENDIF

RETURN cValue 

FUNCTION writeTableProperty
LPARAMETERS cProperty
LOCAL cValue
cValue = DBGETPROP(This.cAlias,"Table",cProperty) 
IF NOT EMPTY(cValue)
\ <tr><th><<cProperty>>:</th><td> <<cValue>> </td></tr>
ENDIF
		
FUNCTION getAttributes
LOCAL cReturn
cReturn = IIF(field_null,", Null","")
cReturn = cReturn + IIF(field_nocp,", NoCP","")
cReturn = SUBSTR(cReturn,3)
RETURN cReturn


FUNCTION getField
LPARAMETERS cReturn
cReturn = field_type
IF INLIST(field_type,'C','N')
	cReturn = cReturn + '('+TRANSFORM(field_len)
	IF field_dec>0
		cReturn = cReturn + ','+TRANSFORM(field_dec)
	ENDIF
	cReturn = cReturn + ')'
ENDIF 
RETURN cReturn


PROCEDURE showSchema
	IF FILE(This.cFileName)	
		DECLARE INTEGER ShellExecute IN shell32; 
	    INTEGER hwnd,; 
	    STRING  lpOperation,; 
	    STRING  lpFile,; 
	    STRING  lpParameters,;  
	    STRING  lpDirectory,; 
	    INTEGER nShowCmd
	    ShellExecute(_vfp.hWnd, 'open', This.cFileName, '','', 3)
	ENDIF
	
	
FUNCTION getCSS
* Default CSS, overridden by Schema.css if it exists
\ body {background : beige; font-family : "Arial";}
\ h1 {color : darkblue; font-size : large;}
\ td {text-align : left; font-family: "Courier New"; padding-left : 3px; padding-right : 10px; }
\ th {text-align : left; }
\ h4 {color : darkblue; }
\ table {margin-bottom : 20px; }
\ #tblHeader {width : 80%; align:left;}
\ #tblSchema {width : 100%; border : 0;}
\ #tblIndices {width : 50%;}
\ #tblViewProps {width: 100%;}
RETURN ""

ENDDEFINE
    