DEFINE CLASS WinApiSupport AS Custom
 
	&& Converts VFP number to the Long integer
	FUNCTION Num2Long(tnNum)
		LOCAL lcString
		lcString = SPACE(4)
		=RtlPL2PS(@lcString, BITOR(tnNum,0), 4)
		RETURN lcString
	ENDFUNC
 
	&& Convert Long integer into VFP numeric variable
	FUNCTION Long2Num(tcLong)
		LOCAL lnNum
		lnNum = 0
		= RtlS2PL(@lnNum, tcLong, 4)
		RETURN lnNum
	ENDFUNC
 
	&&  Return Number from a pointer to DWORD
	FUNCTION Long2NumFromBuffer(tnPointer)
		LOCAL lnNum
		lnNum = 0
		= RtlP2PL(@lnNum, tnPointer, 4)
		RETURN lnNum
	ENDFUNC
 
	&& Convert Short integer into VFP numeric variable
	FUNCTION Short2Num(tcLong)
		LOCAL lnNum
		lnNum = 0
		= RtlS2PL(@lnNum, tcLong, 2)
		RETURN lnNum
	ENDFUNC
 
	&& Retrieve zero-terminated string from a buffer into VFP variable
	FUNCTION StrZFromBuffer(tnPointer)
		LOCAL lcStr, lnStrPointer
		lcStr = SPACE(4096)
		lnStrPointer = 0
		= RtlP2PL(@lnStrPointer, tnPointer, 4)
		lstrcpy(@lcStr, lnStrPointer)
		RETURN LEFT(lcStr, AT(CHR(0),lcStr)-1)
	ENDFUNC
 
	&&  Return a string from a pointer to LPWString (Unicode string)
	FUNCTION StrZFromBufferW(tnPointer)
		Local lcResult, lnStrPointer, lnSen
		lnStrPointer = This.Long2NumFromBuffer(tnPointer)
 
		lnSen = lstrlenW(lnStrPointer) * 2
		lcResult = Replicate(chr(0), lnSen)
		= RtlP2PS(@lcResult, lnStrPointer, lnSen)
		lcResult = StrConv(StrConv(lcResult, 6), 2)
 
		RETURN lcResult
	ENDFUNC
 
	&& Retrieve zero-terminated string 
	FUNCTION StrZCopy(tnPointer)
		LOCAL lcStr, lnStrPointer
		lcStr = SPACE(4096)
		lstrcpy(@lcStr, tnPointer)
		RETURN LEFT(lcStr, AT(CHR(0),lcStr)-1)
	ENDFUNC
 
ENDDEFINE
&&------------------------------------------------------------------------
FUNCTION RtlPL2PS(tcDest, tnSrc, tnLen) 
	DECLARE RtlMoveMemory IN WIN32API AS RtlPL2PS STRING @Dest, Long @Source, Long Length
RETURN 	RtlPL2PS(@tcDest, tnSrc, tnLen) 
 
FUNCTION RtlS2PL(tnDest, tcSrc, tnLen) 
	DECLARE RtlMoveMemory IN WIN32API AS RtlS2PL Long @Dest, String Source, Long Length
RETURN 	RtlS2PL(@tnDest, @tcSrc, tnLen) 
 
FUNCTION RtlP2PL(tnDest, tnSrc, tnLen) 
	DECLARE RtlMoveMemory IN WIN32API AS RtlP2PL Long @Dest, Long Source, Long Length
RETURN 	RtlP2PL(@tnDest, tnSrc, tnLen) 
 
FUNCTION RtlP2PS(tcDest, tnSrc, tnLen) 
	DECLARE RtlMoveMemory IN WIN32API AS RtlP2PS STRING @Dest, Long Source, Long Length
RETURN 	RtlP2PS(@tcDest, tnSrc, tnLen) 
 
FUNCTION lstrcpy (tcDest, tnSrc) 
	DECLARE lstrcpy IN WIN32API STRING @lpstring1, INTEGER lpstring2
RETURN 	lstrcpy (@tcDest, tnSrc) 
 
FUNCTION lstrlenW(tnSrc) 
	DECLARE Long lstrlenW IN WIN32API Long src
RETURN 	lstrlenW(tnSrc)
