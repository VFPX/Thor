********************************************************************************
*  PROGRAM: Thor_Tool_WLCListFields.prg
*
*  AUTHOR:  Richard A. Schummer, May 2011
*
*  COPYRIGHT © 2011   All Rights Reserved.
*     Richard A. Schummer
*     White Light Computing, Inc.
*     42759 Flis Dr.
*     Sterling Heights, MI  48314-2850
*     raschummer@whitelightcomputing.com
*     rick@rickschummer.com
*
*  PROGRAM DESCRIPTION:
*     Program to replace Visual FoxPro LIST FIELDS command. Fields are listed 
*     vertically instead of horizontally (tabular) way Visual FoxPro does. This
*     is done in a way where you can line up the column names and the values stored 
*     in the columns.
*
*  CALLING SYNTAX:
*     DO Thor_tool_wlclistfields.prg WITH [lxParam1], [tcCursorName], [tlModifyFile]
*
*  INPUT PARAMETERS:
*     txParam1     = object if called from VFPX Thor or character if called from 
*                    command line. Object from Thor is used to work with settings. 
*                    When you call with character it is the file name used to create 
*                    and potentially display the column listing (typically a text file)
*     tcCursorName = character, the name of the cursor you want to list fields. 
*                    Optionally used if you want to work with a cursor that is not in 
*                    the current workarea.
*     tlModifyFile = logical, true if you want the text file to be opened after the 
*                    listing is created. This parameter is set to .T. when called from
*                    Thor.
*
*  OUTPUT PARAMETERS:
*     None
*
*  DATABASES ACCESSED:
*     None
* 
*  GLOBAL PROCEDURES REQUIRED:
*     None
* 
*  CODING STANDARDS:
*     Version 4.0 compliant with no exceptions
*  
*  TEST INFORMATION:
*     None
*   
*  SPECIAL REQUIREMENTS/DEVICES:
*     None
*
*  FUTURE ENHANCEMENTS:
*     1) pass in comma-delimited list of field names, and scope
*
*  LANGUAGE/VERSION:
*     Visual FoxPro 09.00.0000.7423 or higher
* 
********************************************************************************
*                             C H A N G E    L O G                              
*
*    Date     Developer               Version  Description
* ----------  ----------------------  -------  ---------------------------------
* 05/20/2011  Richard A. Schummer     1.0      Created Program
* ------------------------------------------------------------------------------
* 05/21/2011  Richard A. Schummer     1.1      Updated to work with VFPX Thor
* ------------------------------------------------------------------------------
*
********************************************************************************
LPARAMETERS txParam1, tcCursorName, tlModifyFile

#DEFINE ccVersion      "v1.1"
#DEFINE ccUTILNAME     "WLC Column Listing Utility"
#DEFINE ccPROGNAME     "thor_tool_wlclistfields"
#DEFINE ccTEXTFILENAME "WLCColListing.txt"
#DEFINE ccNULLTEXT     ".NULL."
#DEFINE ccBLANKTEXT    "(is blank...)"
#DEFINE ccCRLF         CHR(13) + CHR(10)

* Developer controlled settings
#DEFINE clCR_AFTERMEMO .F.

LOCAL loException AS Exception, ;
      lnOldSelect, ;
      llFailedToSelectCursor, ;
      lcOldSafety, ;
      loColListing, ;
      loTools

* Standard prefix for all tools for Thor, allowing this tool to tell Thor about itself.
IF PCOUNT() = 1 AND 'O' = VARTYPE(m.txParam1) AND 'thorinfo' = LOWER(m.txParam1.Class)
   WITH m.txParam1
      * Required
      .Prompt  = ccUTILNAME
      .Summary = "LIST FIELDS replacement by White Light Computing."

      * Optional
      .Source  = "Thor Repository"
	  .Category = 'Tables'
      .Author  = "Rick Schummer"
      .Version = ccVersion

      * For public tools, such as PEM Editor, etc.
      .Link    = "http://www.whitelightcomputing.com/resourcesfreedevelopertools.htm"
   ENDWITH 

   RETURN m.txParam1
ENDIF 

lnOldSelect            = SELECT()
llFailedToSelectCursor = .F.

* Only change cursor if parameter passed (running it without Thor)
DO CASE
   CASE VARTYPE(m.tcCursorName) = "C" AND USED(m.tcCursorName)
      * Nothing to do, all is well

   CASE VARTYPE(m.tcCursorName) = "C" AND NOT USED(m.tcCursorName)
      llFailedToSelectCursor = .T.
      
   OTHERWISE
		****************************************************************
		*  Following two lines make sure PEM Editor IDE Tools are running
		*  and then get the highlighted text, and try to open the file
		*  See also PEME_OpenTable.PRG
		* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20Tools%20Object
		loTools = Execscript (_Screen.cThorDispatcher, 'class= tools from pemeditor')
		loTools.UseHighlightedTable (Set ('Datasession'))
		****************************************************************

      tcCursorName = ALIAS()

ENDCASE 

TRY 
   SELECT (m.tcCursorName)
   
CATCH TO m.loException
   llFailedToSelectCursor = .T.
   
ENDTRY

IF EMPTY(ALIAS()) OR m.llFailedToSelectCursor 
   MESSAGEBOX("Table/cursor not opened or selected to list columns. Please select proper workarea and try again.",;
              0+48, ;
              ccUTILNAME)
ELSE
   lcOldSafety = SET("Safety")
   SET SAFETY OFF 

   loColListing = CREATEOBJECT("WLCColListing", txParam1, tcCursorName, tlModifyFile)
   loColListing.ListColumns()
   loColListing.Release()

   loColListing = NULL

   SET SAFETY &lcOldSafety
ENDIF 

SELECT (m.lnOldSelect)

RETURN 


********************************************************************************
*  CLASS NAME: WLCColListing
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    
*    
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
DEFINE CLASS WLCColListing AS Custom

DIMENSION aFieldList[1,1]
DIMENSION aErrorDetails[1,9]

cCursorName       = SPACE(0)
cFileName         = SPACE(0)
lModifyFile       = .F.
nFields           = 0
nMaxColNameLength = 0
nErrorsRecorded   = 0
xParam1           = NULL


********************************************************************************
*  METHOD NAME: Init
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Initialize the object when the class is instantiated.
* 
*  INPUT PARAMETERS:
*     txParam1     = object if called from VFPX Thor or character if called from 
*                    command line. Object from Thor is used to work with settings. 
*                    When you call with character it is the file name used to create 
*                    and potentially display the column listing (typically a text file)
*     tcCursorName = character, the name of the cursor you want to list fields. 
*                    Optionally used if you want to work with a cursor that is not in 
*                    the current workarea.
*     tlModifyFile = logical, true if you want the text file to be opened after the 
*                    listing is created. This parameter is set to .T. when called from
*                    Thor.
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROCEDURE Init(txParam1, tcCursorName, tlModifyFile)

LOCAL loException AS Exception

this.xParam1     = m.txParam1
this.cCursorName = m.tcCursorName
this.lModifyFile = m.tlModifyFile

* Make sure we have a legal name passed as parameter, or make one up
DO CASE
   CASE VARTYPE(this.xParam1) = "O" OR VARTYPE(this.xParam1) # "C"
      this.cFileName = this.GetListingFileName()

   OTHERWISE
      this.cFileName = ALLTRIM(this.xParam1)
ENDCASE

* Always show the column listing when called from Thor
IF ccPROGNAME $ LOWER(SYS(16, 0))
   * Called independently, not need to change parameters
ELSE
   this.lModifyFile = .T.
ENDIF 

* Move on to setting up the field listing
TRY
   this.InitializeErrorArray() 
   this.GetColumnNames()
   this.GetColumnNameMaxLength()

CATCH TO loException
   * No need to continue
   this.Error(loException.ErrorNo, loException.Procedure, loException.LineNo)

ENDTRY 

RETURN

ENDPROC


********************************************************************************
*  METHOD NAME: ListColumns
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Calls the methods that record the information in the list columns file,
*    and open the list file if requested.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROCEDURE ListColumns()

this.RecordColumnData()
this.WriteErrorsInLog()
this.OpenOutput()

RETURN 

ENDPROC 


********************************************************************************
*  METHOD NAME: RecordColumnData
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Records the data from the table into a text file in a format that is 
*    more readable than the Visual FoxPro LIST FIELDS.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROTECTED PROCEDURE RecordColumnData()

lcTextLine = this.GetListingHeader()
this.WriteOutput(m.lcTextLine, .T.)

IF RECCOUNT() > 0
   lnOldRecNo = RECNO()
   
   SCAN 
      lcTextLine = "*** Record " + TRANSFORM(RECNO()) + SPACE(1) + REPLICATE("*", 50) + ccCRLF

      FOR lnI = 1 TO this.nFields
         lcTextLine = m.lcTextLine + ;
                      " - " + PADR(LOWER(this.aFieldList[lnI, 1]), this.nMaxColNameLength) + " = "
         
         * Address memo, blob, and general differently
         DO CASE
            CASE this.aFieldList[lnI, 2] = "W"
               lcTextLine = m.lcTextLine + ;
                            "(Blob)"

            CASE this.aFieldList[lnI, 2] = "G"
               lcTextLine = m.lcTextLine + ;
                           "(General)"

            OTHERWISE
               lxColContent = EVALUATE(this.aFieldList[lnI, 1])

               * Trying to avoid "String is too long to fit." (1903) error
               TRY 
                  DO CASE
                     CASE ISNULL(m.lxColContent)
                        lxColContent = ccNULLTEXT

                     CASE ISBLANK(m.lxColContent)
                        lxColContent = ccBLANKTEXT

                     OTHERWISE
                        * Nothing to do
                  ENDCASE
               
               CATCH TO loException
                  * No change, as the data is likely to long for the ISBLANK() function to handle

               ENDTRY               

               lcTextLine = m.lcTextLine + ;
                            TRANSFORM(m.lxColContent)

               * Add a carriage return for a memo
               IF clCR_AFTERMEMO AND INLIST(laFields[lnI, 2], "M") AND NOT INLIST(m.lxColContent, ccNULLTEXT, ccBLANKTEXT)
                  lcTextLine = m.lcTextLine + ccCRLF
               ENDIF 
         ENDCASE 
         
         lcTextLine = m.lcTextLine + ccCRLF
      ENDFOR 

      lcTextLine = m.lcTextLine + ccCRLF
      this.WriteOutput(m.lcTextLine)
   ENDSCAN
   
   * Reposition
   IF lnOldRecNo <= RECCOUNT()
      GO (lnOldRecNo)
   ENDIF 
ELSE
   lcTextLine = "No data in the cursor to list." + ccCRLF
   this.WriteOutput(m.lcTextLine)
ENDIF

RETURN 


********************************************************************************
*  METHOD NAME: OpenOutput
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Open the 
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROCEDURE OpenOutput()

IF this.lModifyFile 
   MODIFY FILE (this.cFileName) RANGE 1,1 NOEDIT NOWAIT  
ENDIF 

RETURN 

ENDPROC 


********************************************************************************
*  METHOD NAME: GetColumnNames
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Record the table structure in the aFields array.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    lcReturnVal = character, header for the listing file  
* 
********************************************************************************
PROTECTED PROCEDURE GetColumnNames()

TRY 
   AFIELDS(this.aFieldList)
   this.nFields = ALEN(this.aFieldList, 1)

CATCH TO loException
   this.Error(loException.ErrorNo, loException.Procedure, loException.LineNo)

ENDTRY

RETURN 
   
ENDPROC


********************************************************************************
*  METHOD NAME: GetListingHeader
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Create the field listing heading.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    lcReturnVal = character, header for the listing file  
* 
********************************************************************************
PROTECTED PROCEDURE GetListingHeader()

LOCAL lcReturnVal, ;
      lcOrder, ;
      lcFilter, ;
      lnSourceType

lcOrder      = LOWER(ORDER())
lcFilter     = FILTER()
lnSourceType = CURSORGETPROP("SourceType", ALIAS()) 

lcReturnVal  = ALLTRIM(ccUTILNAME) + SPACE(1) + ccVersion + ccCRLF + ccCRLF
lcReturnVal  = m.lcReturnVal + ;
               "Cursor Alias: " + LOWER(ALIAS()) + ccCRLF
lcReturnVal  = m.lcReturnVal + ;
               "DBF: " + LOWER(FULLPATH(DBF())) + ccCRLF

IF EMPTY(lcOrder)
   lcReturnVal  = m.lcReturnVal + ;
                  "Order: <none>" + ccCRLF
ELSE 
   lcReturnVal  = m.lcReturnVal + ;
                  "Order: " + lcOrder + ccCRLF
ENDIF

IF EMPTY(lcFilter)
   lcReturnVal  = m.lcReturnVal + ;
                  "Filter: <none>" + ccCRLF
ELSE 
   lcReturnVal  = m.lcReturnVal + ;
                  "Filter: " + lcFilter + ccCRLF
ENDIF

lcReturnVal  = m.lcReturnVal + ;
               "Source Type: " 

DO CASE
   CASE INLIST(lnSourceType, 1, 101, 201)
      lcReturnVal = m.lcReturnVal + ;
                    "Data source is a local SQL view"

      IF lnSourceType = 101
         lcReturnVal = m.lcReturnVal + ;
                       ", CursorFill method"
      ELSE
         IF lnSourceType = 201
            lcReturnVal = m.lcReturnVal + ;
                          ", CursorAttach method"
         ENDIF
      ENDIF 
      
      lcReturnVal  = m.lcReturnVal + ;
                     "." + ccCRLF

   CASE INLIST(lnSourceType, 2, 102, 202)
      lcReturnVal = m.lcReturnVal + ;
                    "Data source is a remote SQL view"

      IF lnSourceType = 102
         lcReturnVal = m.lcReturnVal + ;
                       ", CursorFill method"
      ELSE
         IF lnSourceType = 202
            lcReturnVal = m.lcReturnVal + ;
                          ", CursorAttach method"
         ENDIF
      ENDIF 
      
      lcReturnVal  = m.lcReturnVal + ;
                     "." + ccCRLF

   CASE INLIST(lnSourceType, 3, 103, 203)
      lcReturnVal = m.lcReturnVal + ;
                    "Data source is a table"

      IF lnSourceType = 103
         lcReturnVal = m.lcReturnVal + ;
                       ", CursorFill method"
      ELSE
         IF lnSourceType = 203
            lcReturnVal = m.lcReturnVal + ;
                          ", CursorAttach method"
         ENDIF
      ENDIF 
      
      lcReturnVal  = m.lcReturnVal + ;
                     "." + ccCRLF

   CASE INLIST(lnSourceType, 4, 104, 204)
      lcReturnVal = m.lcReturnVal + ;
                    "Based on ADO Recordset"

      IF lnSourceType = 103
         lcReturnVal = m.lcReturnVal + ;
                       ", CursorFill method"
      ELSE
         IF lnSourceType = 203
            lcReturnVal = m.lcReturnVal + ;
                          ", CursorAttach method"
         ENDIF
      ENDIF 
      
      lcReturnVal  = m.lcReturnVal + ;
                     "." + ccCRLF

   OTHERWISE
      * No other options
ENDCASE

lcReturnVal  = m.lcReturnVal + ;
               TRANSFORM(this.nFields) + " columns in this cursor" + ccCRLF + ;
               "Listed on " + TRANSFORM(DATETIME()) + ccCRLF + ccCRLF
             
RETURN lcReturnVal


********************************************************************************
*  METHOD NAME: GetListingFileName
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    This method is called to get the name of the text file used to hold 
*    the field listing.
*    
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    cFileName = character, fully pathed file name in temp folder
* 
********************************************************************************
PROTECTED PROCEDURE GetListingFileName()

this.cFileName = ADDBS(SYS(2023)) + ccTEXTFILENAME

RETURN this.cFileName

ENDPROC 


********************************************************************************
*  METHOD NAME: GetColumnNameMaxLength
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    This method is called to determine the length of the longest column name in
*    the table/cursor so we can line up the values for the column in the record.
*    
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROTECTED PROCEDURE GetColumnNameMaxLength()

LOCAL lnI, ;
      lnThisColNameLength

FOR lnI = 1 TO this.nFields
   lnThisColNameLength = LENC(ALLTRIM(this.aFieldList[lnI, 1]))
   
   IF m.lnThisColNameLength > this.nMaxColNameLength
      this.nMaxColNameLength = m.lnThisColNameLength
   ENDIF 
ENDFOR 

RETURN 

ENDPROC 


********************************************************************************
*  METHOD NAME: WriteOutput
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    This method is to write text out to the text file.
*    
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROTECTED PROCEDURE WriteOutput(tcTextLine, tlStartNewFile)

LOCAL loException AS Exception, ;
      lnStartNewFile

TRY 
   lnStartNewFile = IIF(tlStartNewFile, 0, 1)
   STRTOFILE(m.tcTextLine, this.cFileName, lnStartNewFile)

CATCH TO loException
   this.Error(loException.ErrorNo, loException.Procedure, loException.LineNo)

ENDTRY

RETURN 


********************************************************************************
*  METHOD NAME: InitializeErrorArray
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Reset the aError. 
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROTECTED PROCEDURE InitializeErrorArray() 

DIMENSION aErrorDetails[1,9]

this.aErrorDetails = NULL

RETURN 

ENDPROC 


********************************************************************************
*  METHOD NAME: Error
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Occurs when an error occurs in a method at run time. You can add Error 
*    event code so that the object can handle errors. 
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROCEDURE Error(tnError, tcMethod, tnLine)

LOCAL lnI, ;
      lnRows, ;
      lnCols

DIMENSION laError[1]

AERROR(laError)

IF ISNULL(this.aErrorDetails[1])
   lnRows = 1
ELSE
   lnRows = ALEN(this.aErrorDetails, 1) + 1
ENDIF

* VFP Error array columns, plus two additional for line and method
lnCols = ALEN(laError,2) + 3

DIMENSION this.aErrorDetails[lnRows, lnCols]

FOR lnI = 1 TO lnCols-3
   this.aErrorDetails[lnRows, lnI] = laError[lnI]
ENDFOR

this.aErrorDetails[lnRows, lnI]     = tcMethod
this.aErrorDetails[lnRows, lnI + 1] = tnLine
this.aErrorDetails[lnRows, lnI + 2] = MESSAGE(1)

this.nErrorsRecorded = this.nErrorsRecorded + 1 

DO CASE 
   * Class definition not found (for a hook)
   CASE tnError = 1733
      * Should never happen
      
   OTHERWISE
      * Added in case developer adds superclass to this class
      DODEFAULT(tnError, tcMethod, tnLine)
ENDCASE

RETURN

ENDPROC


********************************************************************************
*  METHOD NAME: WriteErrorsInLog
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Write out the list of errors recorded, if any, to the listing file.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROTECTED PROCEDURE WriteErrorsInLog()

LOCAL lnErrors, ;
      lnCols, ;
      lnRowCounter, ;
      lnColCounter, ;
      lcOutput

lcOutput = SPACE(0)

IF ISNULL(this.aErrorDetails[1])
   * No errors recorded
   lcOutput = ccCRLF + "No errors recorded"
ELSE
   lnErrors = ALEN(this.aErrorDetails, 1)
   lnCols   = ALEN(this.aErrorDetails, 2)

   FOR lnRowCounter = 1 TO lnErrors
      FOR lnColCounter = 1 TO lnCols
         lcOutput = lcOutput + ccCRLF + ;
                    "Error Details[" + TRANSFORM(lnRowCounter) + ;
                    "," + TRANSFORM(lnColCounter) + ;
                    "] = " + ;
                    TRANSFORM(this.aErrorDetails[lnRowCounter, lnColCounter]) + ;
                    SPACE(1)

         DO CASE
            CASE lnColCounter = 1
               lcOutput = lcOutput + ;
                          "(error number)"
            CASE lnColCounter = 2
               lcOutput = lcOutput + ;
                          "(error message)"
            CASE lnColCounter = 3
               lcOutput = lcOutput + ;
                          "(additional error parameter)"
            CASE lnColCounter = 4
               lcOutput = lcOutput + ;
                          "(work area or ODBC SQL state)"
            CASE lnColCounter = 5
               lcOutput = lcOutput + ;
                          "(1–Insert, 2–Update, 3–Delete trigger failed or ODBC DSN)"
            CASE lnColCounter = 6
               lcOutput = lcOutput + ;
                          "(Help context ID or ODBC Connection)"
            CASE lnColCounter = 7
               lcOutput = lcOutput + ;
                          "(OLE 2.0 exception number)"
            CASE lnColCounter = 8
               lcOutput = lcOutput + ;
                          "(method)"
            CASE lnColCounter = 9
               lcOutput = lcOutput + ;
                          "(line#)"
            CASE lnColCounter = 10
               lcOutput = lcOutput + ;
                          "(code)"
         ENDCASE
      ENDFOR

      lcOutput = lcOutput + ccCRLF
   ENDFOR
ENDIF 

this.WriteOutput(lcOutput)

RETURN 

ENDPROC 

********************************************************************************
*  METHOD NAME: Release
*
*  AUTHOR: Richard A. Schummer, May 2011
*
*  METHOD DESCRIPTION:
*    Releases a class instance from memory.
* 
*  INPUT PARAMETERS:
*    None
* 
*  OUTPUT PARAMETERS:
*    None
* 
********************************************************************************
PROCEDURE Release()

RELEASE this

RETURN 

ENDPROC 

ENDDEFINE

*: EOF :*