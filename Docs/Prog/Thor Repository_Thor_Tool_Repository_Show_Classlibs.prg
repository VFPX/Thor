Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
	
		* Required
		.Prompt		   = 'Display Classlibs' && used when tool appears in a menu
		.Description   = 'Display current Classlibs in a dialog box.' && may be lengthy, including CRs, etc
		
		* For public tools, such as PEM Editor, etc.
		.Source	       = 'Thor Repository' 
  	    .Category      = 'Misc.'
		.Author        = 'Matt Slay'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.    

crlf = Chr(13)
lcClassLibs = ' '+ Proper(Set('Classlib'))
lcClassLibs = Strtran(lcClassLibs , ',', crlf)

Messagebox(' ' + lcClassLibs , 0, 'Current Classlibs:')
