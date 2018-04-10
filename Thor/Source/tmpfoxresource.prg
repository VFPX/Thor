* Abstract:
*   Class for add/retrieving values
*	from FoxUser resource file.
*

DEFINE CLASS FoxResource AS Custom
	PROTECTED oCollection
	
	oCollection  = .NULL.

	ResourceType = "PREFW"
	ResourceFile = ''
	
	PROCEDURE Init()
		THIS.oCollection = CREATEOBJECT("Collection")
		THIS.ResourceFile = SYS(2005)
	ENDPROC
	
	PROCEDURE Destroy()
		THIS.CloseResource()
	ENDPROC

	* Clear out all options
	FUNCTION Clear()
		THIS.oCollection.Remove(-1)
	ENDFUNC
	
	FUNCTION Set(cOption, xValue)
		TRY
			THIS.oCollection.Remove(UPPER(m.cOption))
		CATCH
		ENDTRY

		* doesn't exist yet, so add
		RETURN THIS.oCollection.Add(m.xValue, UPPER(m.cOption))
	ENDFUNC
	
	FUNCTION Get(cOption)
		LOCAL xValue
		
		TRY
			m.xValue = THIS.oCollection.Item(UPPER(m.cOption))
		CATCH
			m.xValue = .NULL.
		ENDTRY

		RETURN m.xValue
	ENDFUNC
	
	FUNCTION OpenResource()
		IF !(SET("RESOURCE") == "ON")
			RETURN .F.
		ENDIF

		IF !USED("FoxResource")
			IF FILE(THIS.ResourceFile)
				TRY
					USE (THIS.ResourceFile) ALIAS FoxResource IN 0 SHARED AGAIN
				CATCH
				ENDTRY
			ENDIF
		ENDIF
				
		RETURN USED("FoxResource")
	ENDFUNC
	
	FUNCTION CloseResource()
		IF USED("FoxResource")
			USE IN FoxResource
		ENDIF
	ENDFUNC
	
	PROCEDURE Save(cID, cName)
		LOCAL nSelect
		LOCAL cType
		LOCAL i
		LOCAL ARRAY aOptions[1]
		
		IF VARTYPE(m.cName) <> 'C'
			m.cName = ''
		ENDIF
		IF THIS.OpenResource()
			m.nSelect = SELECT()
			
			m.cType = PADR(THIS.ResourceType, LEN(FoxResource.Type))
			m.cID   = PADR(m.cID, LEN(FoxResource.ID))

			SELECT FoxResource
			LOCATE FOR Type == m.cType AND ID == m.cID AND Name == m.cName
			IF !FOUND()
				APPEND BLANK IN FoxResource
				REPLACE ; 
				  Type WITH m.cType, ;
				  Name WITH m.cName, ;
				  ID WITH m.cID, ;
				  ReadOnly WITH .F. ;
				 IN FoxResource
			ENDIF

			IF !FoxResource.ReadOnly
				IF THIS.oCollection.Count > 0
					DIMENSION aOptions[THIS.oCollection.Count, 2]
					FOR m.i = 1 TO THIS.oCollection.Count
						aOptions[m.i, 1] = THIS.oCollection.GetKey(m.i)
						aOptions[m.i, 2] = THIS.oCollection.Item(m.i)
					ENDFOR
					SAVE TO MEMO Data ALL LIKE aOptions
				ELSE
					BLANK FIELDS Data IN FoxResource
				ENDIF

				REPLACE ;
				  Updated WITH DATE(), ;
				  ckval WITH VAL(SYS(2007, FoxResource.Data)) ;
				 IN FoxResource
			ENDIF
		
			THIS.CloseResource()
			
			SELECT (m.nSelect)
		ENDIF
	ENDPROC
	
	PROCEDURE Load(cID, cName)
		LOCAL nSelect
		LOCAL cType
		LOCAL i
		LOCAL nCnt
		LOCAL ARRAY aOptions[1]
		
		IF VARTYPE(m.cName) <> 'C'
			m.cName = ''
		ENDIF
		
		* THIS.Clear()
		IF THIS.OpenResource()
			m.nSelect = SELECT()
			
			m.cType = PADR(THIS.ResourceType, LEN(FoxResource.Type))
			m.cID   = PADR(m.cID, LEN(FoxResource.ID))

			SELECT FoxResource
			LOCATE FOR Type == m.cType AND ID == m.cID AND Name == m.cName
			IF FOUND() AND !EMPTY(Data) AND ckval == VAL(SYS(2007, Data))
				RESTORE FROM MEMO Data ADDITIVE
				IF VARTYPE(aOptions[1,1]) == 'C'
					m.nCnt = ALEN(aOptions, 1)
					FOR m.i = 1 TO m.nCnt
						THIS.Set(aOptions[m.i, 1], aOptions[m.i, 2])
					ENDFOR
				ENDIF
			ENDIF

			THIS.CloseResource()			

			SELECT (m.nSelect)
		ENDIF
	ENDPROC

	FUNCTION GetData(cID, cName)
		LOCAL cData
		LOCAL nSelect
		LOCAL cType

		IF VARTYPE(m.cName) <> 'C'
			m.cName = ''
		ENDIF

		m.cData = .NULL.
		IF THIS.OpenResource()
			m.nSelect = SELECT()
			
			m.cType = PADR(THIS.ResourceType, LEN(FoxResource.Type))
			m.cID   = PADR(m.cID, LEN(FoxResource.ID))

			SELECT FoxResource
			LOCATE FOR Type == m.cType AND ID == m.cID AND Name == m.cName
			IF FOUND() AND !EMPTY(Data) && AND ckval == VAL(SYS(2007, Data))
				m.cData = FoxResource.Data
			ENDIF

			THIS.CloseResource()
	
			SELECT (m.nSelect)
		ENDIF
		
		RETURN m.cData
	ENDFUNC

	FUNCTION SetData(cID, cName, cSetData, nCkVal)
		LOCAL nSelect
		LOCAL cType
		LOCAL lSuccess

		IF VARTYPE(m.cName) <> 'C'
			m.cName = ''
		ENDIF

		m.lSuccess = .F.
		IF THIS.OpenResource()
			m.nSelect = SELECT()
			
			m.cType = PADR(THIS.ResourceType, LEN(FoxResource.Type))
			m.cID   = PADR(m.cID, LEN(FoxResource.ID))

			SELECT FoxResource
			LOCATE FOR Type == m.cType AND ID == m.cID AND Name == m.cName
			IF !FOUND()
				APPEND BLANK IN FoxResource
				REPLACE ; 
				  Type WITH m.cType, ;
				  Name WITH m.cName, ;
				  ID WITH m.cID, ;
				  ReadOnly WITH .F. ;
				 IN FoxResource
			ENDIF			

			IF !FoxResource.ReadOnly
				REPLACE Data WITH m.cSetData IN FoxResource

				IF VARTYPE(nCkVal) <> 'N'
					nCkVal = VAL(SYS(2007, FoxResource.Data))
				ENDIF

				REPLACE ;
				  Updated WITH DATE(), ;
				  ckval WITH nCkVal ;
				 IN FoxResource

				m.lSuccess = .T.
			ENDIF


			THIS.CloseResource()
	
			SELECT (m.nSelect)
		ENDIF
		
		RETURN m.lSuccess
	ENDFUNC
	
	* Add an item to an MRU list
	FUNCTION AddToMRU(cMRUName, cMRUItem)
		LOCAL cMRUData
		LOCAL nSelect
		LOCAL i
		LOCAL nCnt
		LOCAL ARRAY aMRUList[1]

		IF THIS.OpenResource()
			m.nSelect = SELECT()
			
			m.cType    = PADR(THIS.ResourceType, LEN(FoxResource.Type))
			m.cMRUName = PADR(m.cMRUName, LEN(FoxResource.ID))
			
			SELECT FoxResource
			LOCATE FOR Type == m.cType AND ID == m.cMRUName AND EMPTY(Name)
			IF !FOUND()
				APPEND BLANK IN FoxResource
				REPLACE ; 
				  Type WITH m.cType, ;
				  Name WITH '', ;
				  ID WITH m.cMRUName, ;
				  ReadOnly WITH .F., ;
				  Data WITH CHR(4) + CHR(0) + CHR(0) ;
				 IN FoxResource
			ENDIF
			IF !FoxResource.ReadOnly
				m.nCnt = ALINES(aMRUList, SUBSTR(FoxResource.Data, 3), .F., CHR(0))

				m.cMRUList = m.cMRUItem + CHR(0)
				FOR m.i = 1 TO m.nCnt
					IF !(UPPER(m.cMRUItem) == UPPER(aMRUList[m.i]))
						m.cMRUList = m.cMRUList + aMRUList[m.i] + CHR(0)
					ENDIF
				ENDFOR
				m.cMRUList = m.cMRUList + CHR(0)
			
				REPLACE ;
				  Data WITH CHR(4) + CHR(0) + m.cMRUList, ;
				  CkVal WITH VAL(SYS(2007, m.cMRUList)), ;
				  Updated WITH DATE() ;
				 IN FoxResource

				m.lSuccess = .T.
			ENDIF

			THIS.CloseResource()
	
			SELECT (m.nSelect)
		ENDIF
	ENDFUNC

	* save to a specific fieldname
	FUNCTION SaveTo(cField, cAlias)
		LOCAL i
		LOCAL nSelect
		LOCAL lSuccess
		LOCAL ARRAY aOptions[1]

		IF VARTYPE(m.cAlias) <> 'C'
			m.cAlias = ALIAS()
		ENDIF

		IF USED(m.cAlias)
			m.nSelect = SELECT()
			SELECT (m.cAlias)

			IF THIS.oCollection.Count > 0
				DIMENSION aOptions[THIS.oCollection.Count, 2]
				FOR m.i = 1 TO THIS.oCollection.Count
					aOptions[m.i, 1] = THIS.oCollection.GetKey(m.i)
					aOptions[m.i, 2] = THIS.oCollection.Item(m.i)
				ENDFOR
				SAVE TO MEMO &cField ALL LIKE aOptions
			ELSE
				BLANK FIELDS &cField IN FoxResource
			ENDIF
			SELECT (m.nSelect)
			m.lSuccess = .T.
		ELSE
			m.lSuccess = .F.
		ENDIF
		
		RETURN m.lSuccess
	ENDFUNC


	FUNCTION RestoreFrom(cField, cAlias)
		LOCAL i
		LOCAL nSelect
		LOCAL lSuccess
		LOCAL ARRAY aOptions[1]

		IF VARTYPE(m.cAlias) <> 'C'
			m.cAlias = ALIAS()
		ENDIF

		IF USED(m.cAlias)
			m.nSelect = SELECT()
			SELECT (m.cAlias)

			RESTORE FROM MEMO &cField ADDITIVE
			IF VARTYPE(aOptions[1,1]) == 'C'
				m.nCnt = ALEN(aOptions, 1)
				FOR m.i = 1 TO m.nCnt
					THIS.Set(aOptions[m.i, 1], aOptions[m.i, 2])
				ENDFOR
			ENDIF

			SELECT (m.nSelect)
			m.lSuccess = .T.
		ELSE
			m.lSuccess = .F.
		ENDIF
		
		RETURN m.lSuccess
	ENDFUNC
ENDDEFINE

