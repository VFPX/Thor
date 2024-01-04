Local lnCount, lnI, loActiveProject, loActiveProjectName, loProject

lnCount = _vfp.Projects.Count
If m.lnCount > 0

	_Screen.AddProperty('aThorCFUProjects(lnCount, 3)')

	loActiveProjectName = Upper(_vfp.ActiveProject.Name)

	For lnI = 1 To m.lnCount
		loProject = _vfp.Projects[m.lnI]

		_Screen.aThorCFUProjects(m.lnI, 1) = m.loProject.Name
		_Screen.aThorCFUProjects(m.lnI, 2) = m.loProject.Visible
		_Screen.aThorCFUProjects(m.lnI, 3) = Upper(m.loProject.Name) == m.loActiveProjectName
	Endfor

	Asort(_Screen.aThorCFUProjects, 3)

	loActiveProject	= Null
	loProject		= Null

Else

	Removeproperty(_Screen, 'aThorCFUProjects')

Endif

