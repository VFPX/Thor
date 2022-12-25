#Define VersionFile         		'ThorVersion.h'
#Define UpdaterVersionFile  	  	'..\Installation Folder\_ThorVersionFile.txt'
#Define UpdaterVersionFileBeta	  	'..\Installation Folder - Beta\ThorVersionFileBeta.txt'

#Define CRLF                		Chr(13) + Chr(10)

Local laLines[1], lcNewText, lcNewVersion, lcOldVersion, lcText, lcURL, lcUpdateVersionFile
Local lcVersion, lnI, lnPos

Alines(laLines, Filetostr(VersionFile))
lcOldVersion = Substr(laLines(1), 3)
If Occurs('.', lcOldVersion) = 3
	lnPos		 = At('.', lcOldVersion, 3)
	lcOldVersion = Left(lcOldVersion, lnPos) + Transform(Val(Substr(lcOldVersion, lnPos + 1)) + 1, '@L 99') + ' Beta'
Endif

lcVersion = Inputbox ('New Version: ', '', lcOldVersion)
If Empty (lcVersion)
	Return
Endif

If Upper ('Beta') $ Upper (lcVersion)
	lcUpdateVersionFile	= UpdaterVersionFileBeta
	lcURL				= 'http://vfpxrepository.com/dl/thorupdate/thor/Thor_Beta/Thor.zip'
	lcAltURL			= 'http://vfpxrepository.com/dl/thorupdate/thor/Thor_Beta/Thor.zip'
	lcURL				= 'http://bit.ly/ThorZipFromZZZZZZZZZZZZZVFPxRepository'
Else
	lcUpdateVersionFile	= UpdaterVersionFile
	lcURL				= 'http://bit.ly/ThorZipFromVFPxRepository'
	lcAltURL			= 'http://vfpxrepository.com/dl/thorupdate/thor/Thor.zip'
Endif

*********************************************************
lcNewVersion = CreateCloudVersionFile ('Thor', lcVersion, lcURL, lcUpdateVersionFile, 'Thor Home Page', ;
	  'http://vfpx.codeplex.com/wikipage?title=Thor',											;
	  '', lcAltURL)

lcNewText = '* ' + lcVersion
lcNewText = lcNewText + CRLF + ''
lcNewText = lcNewText + CRLF + '#Define cnVersion         ' + Alltrim (lcVersion)
lcNewText = lcNewText + CRLF + '#Define cdVersionDate     ' + SpellDate()
lcNewText = lcNewText + CRLF + '#Define	ccThorInternalVERSION     [' + lcNewVersion + ']'
lcNewText = lcNewText + CRLF + '#Define	ccThorVERSION     [' + Alltrim(Left(lcNewVersion, Rat('-', lcNewVersion) - 1)) + ']'

If Upper ('Beta') $ Upper (lcVersion)
	lcNewText			= lcNewText + CRLF + '#Define	ccThorVERSIONFILE [ThorVersionBeta.txt]'
Else
	lcNewText			= lcNewText + CRLF + '#Define	ccThorVERSIONFILE [ThorVersion.txt]'
Endif

Erase (VersionFile)
Strtofile (lcNewText, VersionFile, 0)

*********************************************************

Return lcNewVersion
