Lparameters lcPrefix, lcVersion, lcSourceURL, lcUpdateVersionFile, lcLinkPrompt, lcLink, tcNote, lcAltSourceUTL

*********************************************************
Local lcNewVersion, lcText
lcNewVersion = lcPrefix + ' - ' + Alltrim (lcVersion) + [ - ] + SpellDate() + ' - ' + Dtoc(Date(),1)

Text To lcText Noshow Textmerge
Lparameters toUpdateInfo

Local lcNote
AddProperty(toUpdateInfo, 'AvailableVersion',	'<<lcNewVersion>>')
AddProperty(toUpdateInfo, 'SourceFileUrl', 		'<<lcSourceURL>>')
AddProperty(toUpdateInfo, 'AltSourceFileUrl', 	'<<Evl(lcAltSourceUTL, "")>>')
AddProperty(toUpdateInfo, 'LinkPrompt', 		'<<Evl(lcLinkPrompt, "")>>')
AddProperty(toUpdateInfo, 'Link', 				'<<Evl(lcLink, "")>>')

###Text to lcNote NoShow
<<Evl(tcNote, '')>>
###EndText

AddProperty(toUpdateInfo, 'Notes', 				lcNote)

Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo)
Return toUpdateInfo

Endtext

lcText = Strtran(lcText, '###', '')

Erase (lcUpdateVersionFile)
Strtofile (lcText, lcUpdateVersionFile, 0)
*********************************************************

Return lcNewVersion
