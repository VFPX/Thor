Local lnProj

IF !EMPTY(_SCREEN.gaFiles(1,1)) THEN
 FOR lnProj = 1 TO ALEN(_SCREEN.gaFiles,1)
  IF _SCREEN.gaFiles(m.lnProj,2) THEN
   MODIFY PROJECT (_SCREEN.gaFiles(m.lnProj,1)) NOWAIT
  ELSE  &&_SCREEN.gaFiles(m.lnProj,2) THEN
   MODIFY PROJECT (_SCREEN.gaFiles(m.lnProj,1)) NOWAIT NOSHOW
  ENDIF &&_SCREEN.gaFiles(m.lnProj,2) THEN
 ENDFOR &&lnProj
ENDIF &&!EMPTY(_SCREEN.gaFiles(1,1)) THEN
REMOVEPROPERTY(_SCREEN,"gaFiles")
 
