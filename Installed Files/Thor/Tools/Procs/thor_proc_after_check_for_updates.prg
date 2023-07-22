Local lnProj

IF !EMPTY(_SCREEN.aThorCFUProjects(1,1)) THEN
 FOR lnProj = 1 TO ALEN(_SCREEN.aThorCFUProjects,1)
  IF _SCREEN.aThorCFUProjects(m.lnProj,2) THEN
   MODIFY PROJECT (_SCREEN.aThorCFUProjects(m.lnProj,1)) NOWAIT
  ELSE  &&_SCREEN.aThorCFUProjects(m.lnProj,2) THEN
   MODIFY PROJECT (_SCREEN.aThorCFUProjects(m.lnProj,1)) NOWAIT NOSHOW
  ENDIF &&_SCREEN.aThorCFUProjects(m.lnProj,2) THEN
 ENDFOR &&lnProj
ENDIF &&!EMPTY(_SCREEN.aThorCFUProjects(1,1)) THEN
REMOVEPROPERTY(_SCREEN,"aThorCFUProjects")


