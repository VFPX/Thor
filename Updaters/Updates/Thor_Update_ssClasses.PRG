lparameters loUpdateObject

Local lcNotes, lcRegisterWithThor

* Code to be executed when the this project is installed by Thor
Text to lcRegisterWithThor NoShow TextMerge
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"ssClasses downloaded...", 3000)
EndText

* Notes to appear in Check For Updates (at the bottom) 
Text to lcNotes NoShow
    New on this update:
    ssPolyClock New Themes and Skins
    ssButton - migrated from sandstorm36 library
    ssContainer - migrated from sandstorm36 library
    ssSwitch - new/modified themes
    ssOptSwitch - faster switching, cleaner codes

    ssThrobber - new animation, new features.  In the meantime, you need to register this to the WS it will be used until such time
                 I learn the "proper" usage of an internal/external manifest.  Please read this: 
                 http://sandstorm36.blogspot.com.au/2013/01/ssthrobber.html

    Enjoy!

    Please visit: http://sandstorm36.blogspot.com.au/ for details   
EndText

With loUpdateObject

	* The name of the application (and also the folder it is stored in)
    .ApplicationName      = 'ssClasses'

    * Is this application a Component (if not, then a tool used in IDE)
    .Component            = 'Yes'

    * Current version number, in a very specific format, separated by dashes:
    *   Application Name - Version Number - Version Date for display - Version Number (YYYYMMDD)
    .AvailableVersion     = 'ssClasses - 3.0 Alpha - Feb. 1, 2013 - 20130201'

	* The name of the text file containing the version currently installed.
    .VersionLocalFilename = 'ssClassesVersionFile.txt'

	* URL for the ZIP file 
    .SourceFileUrl        = 'https://github.com/VFPX/ssClasses/archive/refs/heads/master.zip'
    
    * URL for the home page for the project
    .Link                 = 'https://github.com/VFPX/ssClasses'
    
    * Prompt to be used in the Check for Updates screen to access the home paeg
    .LinkPrompt           = 'ssClasses Home Page'

    * The code to be executed when the this project is installed by Thor
    .RegisterWithThor     = lcRegisterWithThor

	* Notes to appear in Check For Updates (at the bottom) 
    .Notes                = lcNotes
EndWith

Return loUpdateObject

