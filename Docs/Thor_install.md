First-Time and Manual Installation of Thor
===

Note:  Starting with Thor Version 1.1, updates to Thor can be obtained by using [One-Click Update of Thor](Thor_one-click_update.md). This page applies to the initial installation of Thor or should it happen that the One-Click Update is not working.
### **Choosing an installation folder**

Thor must be installed in a permanent folder; it creates some folders and tables which must always be available. It is suggested that it be installed in a folder that you regularly back up.  

There are two different strategies for selecting an installation folder for Thor:

1.  Install it in a common folder (such as in your path), so that Thor.App can be easily accessed
2.  Install it in its own separate folder, and then use RunThor.PRG (see below) to access Thor.App 

[**Click here to download the current version of Thor**](https://github.com/VFPX/Thor/archive/master.zip) 



### **Installing Thor**

After you have downloaded the Zip file into its installation folder, do the following:  


    Clear All
    Do Thor.APP

This will

*   create a folder named Thor in the installation folder
*   create some sub-folders and files in that folder
*   update the VFP system menu (by adding a menu pad for Thor)
*   run ["Check for Updates"](Thor_one-click_update.md) so that you it can download and install [PEM Editor](https://github.com/VFPX/PEMEditor) and [The Thor Repository](Thor_repository.md), which are necessary components for Thor
*   and open the Thor form.

Note the installation does not affect VFP in any other way (it does not SET any variables, modify foxcode, etc.) and may safely be repeated as many times as desired.
