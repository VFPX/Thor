Erase xxx.html
StrToFile(CreateThorToolCatalogVFPx('thor repository,ide tools'), 'xxx.html')
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
	loLink.ShellExecute ('xxx.html')
