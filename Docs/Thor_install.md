First-Time and Manual Installation of Thor
===

*Note:* starting with Thor Version 1.1, Thor updates can be obtained by using [One-Click Update of Thor](Thor_one-click_update.md). This page only applies to the **initial installation** of Thor or should it happen that the One-Click Update is not working.

### Installing Thor

1. [Download current version of Thor.](https://github.com/VFPX/Thor/raw/master/ThorUpdater/Thor.zip)

2. Extract the contents of the ZIP file to the installation folder of your choice (see details below on how to [choose an installation folder](#choosing-an-installation-folder) ). After this step your installation folder should contain Thor.APP and two folders, named Thor and Source.
3. Open Visual FoxPro and run the following commands in the command window:

        Clear All
        Do C:\MyThorInstallFolder\Thor.APP

    where _C:\MyThorInstallFolder_ is the folder you extracted the ZIP file to. Alternatively, if your Thor installation folder is in your PATH, simply:

        Clear All
        Do Thor.APP

This does a few things:

*   Creates some sub-folders and files in the installation folder.
*   Updates the VFP system menu by adding a menu pad for Thor.
*   Automatically runs ["Check for Updates"](Thor_one-click_update.md) so that you can download and install the following projects which are required components to run Thor:

    * [The Thor Repository](https://github.com/VFPX/ThorRepository)
    * [PEM Editor](https://github.com/VFPX/PEMEditor)
    * [Dynamic Forms](https://github.com/VFPX/DynamicForms)

*   And finally opens up the Thor Configuration Form.

*Note:* Thor does not affect VFP in any other way (it does not SET any variables, modify foxcode, etc.) and the installation process can be safely repeated as many times as desired.

#### Choosing an installation folder

Thor must be installed into permanent folder; it creates some folders and tables which must always be available. We suggest to install Thor into a folder that is backed up on a regular basis. The installation folder doesn't need to be a VFP sub-folder.

There are two different strategies when selecting an installation folder for Thor:

1.  Install it in a common folder (such as in your PATH), so that Thor.APP can be easily accessible
2.  Install it in its own separate folder, and then use [RunThor.PRG](Thor_running.md) to access Thor.APP

## If Installation or Check for Updates Fails

Check the update log for messages that may help track down the problem:

```
modify file (_screen.cthorlogforcfu)
```
