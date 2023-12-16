Running Thor
===

**Thor** needs to be started only once each IDE session, since it survives Clear All.

The recommended method for starting Thor, calling `RunThor.PRG` instead of `Thor.App`, allows ‘Check For Updates’ to be called automatically in the first IDE session of the day, at an interval of your choosing.

`RunThor.PRG` is created in the Thor sub-folder and can be copied anywhere (such as to a folder in the path) since it contains an explicit reference to the folder where Thor is installed. It is to be called like this:  

    Do RunThor with tnDays, tlInstallAllUpdates

This should be placed as early in the setup for your IDE as possible so that any new updates can be downloaded before any other programs are running. Remember that ‘Check for Updates’ performs a ‘Clear All’ if any updates are installed.

The parameter `tnDays` is the interval in days between calls to ‘Check for Updates’. A value of 1 means that it will be performed in your first IDE session of each day; a value of 7 means once a week. If the parameter is missing or is not a positive number, ‘Check For Updates’ is not called.

The parameter `tlInstallAllUpdates` is to be set to .T. if you want the updates to proceed without bothering to ask you whether you want to install them.

The old mechanism for starting Thor, by calling Thor.App directly (see below), still works, but cannot invoke the ‘Check For Updates’ process.

    Do Thor.APP

**Note**: The distinction here is that `Thor.APP` cannot be moved from its installation folder (if so, it has to be re-installed). `RunThor.PRG` **can** be moved, as it contains an explicit reference to the folder where `Thor.APP` is installed.

`Thor.App` can also be called with a single parameter for a variety of related tasks:

Parameter|Description
---|---
(none)|Runs Thor: Creates system menus and sub-menus, popup menus, and assigns hot keys to tools and popup menus.
‘Edit’|Opens the Thor form
‘Help’|Opens the Thor help page … [Thor Help](Thor_help.md)
‘Clear HotKeys’|Removes all hot key assignments.
‘Install’|Installs the current version of ‘Thor’.
‘Run’|Same as no parameter (deprecated)
