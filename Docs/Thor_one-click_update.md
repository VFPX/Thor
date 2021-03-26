One-Click Updates of Thor (aka "Check for Updates")
===

Updates to [Thor](Thor.md), the [Thor Repository](Thor_repository.md), [PEM Editor 7](https://github.com/VFPX/PEMEditor) with IDE Tools, and other tools, as well as all of the projects from [VFPX](https://github.com/VFPX), are all available through a single menu on the Thor menu (in the FoxPro system menu).  This item, ‘Check for Updates’, checks to see if there are updates available for any of these APPs; if any are found, they are automatically downloaded and installed.

![](Images/Thor_One-Cick_Update_image_4.png)


“Check for Updates” begins by determining whether there is a newer version of Thor itself. If so, it displays a message like the following:

![](Images/Thor_One-Cick_Update_SNAGHTML17f44631.png)

It then proceeds to check for updates to all of the other available applications and tools, as shown below.  Note that [PEM Editor](https://github.com/VFPX/PEMEditor) and the [Thor Repository](Thor_repository.md) are essential parts of [Thor](Thor.md); you should download them immediately and update them any time that they show on the “Check for Updates” form. The items in green on the form are those that have been updated recently

![](Images/Thor_One-Cick_Update_SNAGHTML1f1f7c63.png)

The projects listed in Check For Updates are listed alphabetically within these five groups:

1.  Projects that you have already downloaded for which there is a more current version. (see #4)
2.  Projects that you have not downloaded which have had updates in the last three months
3.  All other projects that you have not downloaded
4.  Projects that you have already downloaded and which are current
5.  All projects marked as “never update”. This takes precedence over any of the other categories.

### Where are these updates installed?

If you already have versions of [Thor](Thor.md), [PEM Editor](https://github.com/VFPX/PEMEditor), or [GoFish](https://github.com/mattslay/GoFish) installed, this update process will replace the installed versions with the newer versions.  You will ***not*** lose any work you had already done in the folders for these already installed tools.

If you did ***not*** have prior versions installed, then the update process will install them in a subfolder of the Thor folder named `Thor\Tools\Apps` or `Thor\Tools\Components`. "Apps" are tools typically used within the FoxPro IDE by developers (i.e. Project Explorer, FoxTabs, GoFish, FoxUnit, etc.), and "Components" are items that are typically used in your distributed apps for end users (i.e. Fox Charts, Dynamic Forms, nfJson, etc.).


### Important Note

The applications that are automatically downloaded as part of ‘Checking for Updates’ are not only downloaded, but they are also installed and ready to run.  There is nothing else you need to do in order to start using them.

### Recommendations

Thor is started by running RunThor.PRG, a file that is created as part of the installation process. This file can be copied into any other folder you wish (such as in your path), since it contains an explicit reference to the folder where you installed Thor.

1.  Since this process works best if run right after launching FoxPro, before you begin working and BEFORE opening PEM Editor, and with no other FoxPro sessions running, we recommend that you call RunThor as part of your IDE setup
2.  As Thor continues to evolved there are updates from time to time. We recommend calling RunThor with a parameter of 7 so that “Check For Updates” is run automatically every week.
