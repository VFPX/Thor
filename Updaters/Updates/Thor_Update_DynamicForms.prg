Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Dynamic Form downloaded...", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
	.AppName		  			= ''
	.ApplicationName		= 'Dynamic Forms'
    .Component				= 'Yes'
    .RegisterWithThor		= lcRegisterWithThor
    
    .Link						= 'https://github.com/VFPX/DynamicForms'
    .LinkPrompt				= 'Dynamic Form Home Page'
    .Notes					= GetNotes()

	.ToolName					= '' && This is not a "tool", it's a "component".
	.VersionFileURL			= 'https://raw.githubusercontent.com/VFPX/DynamicForms/master/_DynamicFormVersionFile.txt'
	.VersionLocalFilename	= 'DynamicFormVersionFile.txt'
	
	Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
	
    Text to lcNotes NoShow
Dynamic Forms is a new way to create forms based on a "markup syntax" similar to HTML and XAML, in which you specify both the layout and ControlSources for the various controls to be displayed on the form.

The result will be a dynamically constructed form, specified in code, rather than manually creating in the Form Designer.
    EndText
    Return lcNotes
EndProc
