Local lnProj, loProject

ADDPROPERTY(_SCREEN,"gaFiles(1,2)")
IF _VFP.PROJECTS.COUNT>0 THEN
 DIMENSION;
  _SCREEN.gaFiles(_VFP.PROJECTS.COUNT,2)
ENDIF &&_VFP.PROJECTS.COUNT>0
_SCREEN.gaFiles = ""

lnProj     = 0
FOR EACH m.loProject IN _VFP.PROJECTS FOXOBJECT
 lnProj							= m.lnProj+1
 _SCREEN.gaFiles(m.lnProj,1)	= m.loProject.NAME
 _SCREEN.gaFiles(m.lnProj,2)	= m.loProject.VISIBLE
ENDFOR &&loProject
 
 
