# Thor Check for Updates Process

* Note: some people have a directory structure like this:

ThorInstallFolder  
  +- Thor.app  
  +- Thor  
     ++- RunThor.prg  
     ++- Source  
     ++- Tables  
     ++- Tools  

Others have this:

ThorInstallFolder  
  +- Docs  
  +- Thor  
     ++- Thor.app  
     ++- Source  
     ++- Thor  
        +++- RunThor.prg  
        +++- Tables  
        +++- Tools

* Check for Updates (either the Check for Updates function in the Thor menu or the automatic check for updates done periodically at Thor startup) calls Thor_Proc_Check_For_Updates.prg (note: this and all other PRGs discussed are in Thor\Tools\Procs).

* Thor_Proc_Check_For_Updates.prg starts by calling Thor_Proc_DownloadAndInstallUpdates.prg, passing .T. as the tlIsThor parameter to indicate we are updating Thor itself (see the discussion of Thor_Proc_DownloadAndInstallUpdates.prg below).

* Thor_Proc_Check_For_Updates.prg then deletes all FXP files in the Thor\Tools folder and its Procs and My Tools subdirectories, and all PRGs in its Updates subdirectory except Thor_Update_Thor.prg, which is used to update Thor itself.

* It then calls Thor_Proc_DownloadAndExtractToPath.prg to download a hard-coded URL of http://vfpxrepository.com/dl/thorupdate/Updater_PRGs/Updates.zip and unzip it in the Thor\Tools\Updates folder. This zip file contains one PRG per tool, such as Thor_Update_CodeAnalyst.prg.

* It then calls Thor_Proc_DownloadAndInstallUpdates.prg to process the other tools.

* Thor_Proc_DownloadAndInstallUpdates.prg calls Thor_Proc_GetUpdateList.prg, which calls its AddUpdateFolder function to do most of the work.

	* Thor_Proc_GetUpdateList.prg creates a collection of updater objects (defined in Thor_Proc_GetUpdaterObject2.prg), one for each PRG in Thor\Tools\Updates. The properties of each object are set by calling the PRG, including the SourceFileURL property which specifies the download file (usually a ZIP file) for the tool. Note: if a file with the same name as the tool updater PRG also exists in Thor\Tools\Updates\Removed, that updater PRG is skipped. Also note: if tlIsThor is .T., which it is when Thor_Proc_DownloadAndInstallUpdates.prg is called the first time, only Thor_Update_Thor.prg is added to the collection so only Thor is updated.

	* Thor_Proc_GetUpdateList.prg checks whether the tool is already installed or not and if so, gets the installed version number by reading the content of the version file, whose name is specified in the VersionLocalFileName property of the updater object, from the tool's install folder (which is a subdirectory of either Thor\Tools\Apps or Thor\Tools\Components, depending on whether the Component property is "Yes" or not) into the CurrentVersion property. The NeverUpdate property is set to "Yes" if a file with the same name as the tool updater PRG also exists in Thor\Tools\Updates\Never Update.

* Thor_Proc_DownloadAndInstallUpdates.prg then calls its GetAvailableVersionInfo function, which goes through the updater collection and calls Thor_Proc_GetAvailableVersionInfo.prg for each one which doesn't have NeverUpdate set to "Yes".

	* Thor_Proc_GetAvailableVersionInfo.prg calls Thor_Proc_DownloadFileFromURL.prg to download from the URL specified in the VersionFileURL property of the updater object to a file in the temp folder whose name is specified in the VersionLocalFilename property of the updater object. It logs the process by calling Thor_Proc_WriteToCFULog.prg.

	* Thor_Proc_GetAvailableVersionInfo.prg then executes the VFP code in the downloaded file, passing it the updater object so it can set properties of it, especially the AvailableVersion property.

* Depending on whether tlIsThor is .T. or not, Thor_Proc_DownloadAndInstallUpdates.prg then either calls its SelectFromUpdateList and CheckIfReadyToGo functions or its SelectUpdates function.

	* SelectFromUpdateList populates and returns another collection of updater objects, those that have different values for AvailableVersion and CurrentVersion.

	* CheckIfReadyToGo prompts the user to run the update.

	* SelectUpdates displays a dialog allowing the user to select which tools to update or install, and returns a collection of the tools the user chose.

* If there are tools to process, Thor_Proc_DownloadAndInstallUpdates.prg calls its ClearAll function to preserve a list of tools, then does CLEAR ALL and CLOSE ALL. Thor_Proc_DownloadAndInstallUpdates.prg then calls its InstallUpdates function to do the download and installation.

	* InstallUpdates goes through each tool to be processed, creates the tool install folder if necessary, calls a hook procedure named Thor_Proc_BeforeComponentInstall.prg (which by default has no code) if the tool is a component, and then calls Thor_Proc_DownloadAndExtractToPath.prg to download the tool's installation file.

		* Thor_Proc_DownloadAndExtractToPath.prg calls Thor_Proc_DownloadFileFromURL.prg to download the tool's file to a temporary file in the temp folder and then calls Thor_Proc_ExtractToPath.prg to extract the ZIP file to the tool's install folder.

	* If Thor_Proc_DownloadAndExtractToPath.prg fails and the tool specifies another download URL in the updater object's AltSourceFileURL property (which isn't defined in Thor_Proc_GetUpdaterObject2.prg but can be added to the object at some point), InstallUpdates calls Thor_Proc_DownloadFileFromURL.prg again, this time with AltSourceFileURL as the download URL.

