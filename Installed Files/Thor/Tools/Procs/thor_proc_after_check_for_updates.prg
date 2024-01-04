Local lcProject, llVisible, lnI, loException

If Type('Alen(_Screen.aThorCFUProjects)') = 'N'

	For lnI = 1 To Alen(_Screen.aThorCFUProjects, 1)
		lcProject = _Screen.aThorCFUProjects(m.lnI, 1)
		llVisible = _Screen.aThorCFUProjects(m.lnI, 2)

		Try
			If m.llVisible
				Modify Project (m.lcProject) Nowait
			Else
				Modify Project (m.lcProject) Nowait Noshow
			Endif
		Catch To m.loException

		Endtry

	Endfor

	Removeproperty(_Screen, 'aThorCFUProjects')
Endif && Type("Alen(_Screen.aThorCFUProjects)") = 'N'
