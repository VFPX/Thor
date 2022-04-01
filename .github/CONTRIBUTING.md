# How to contribute to Thor

## Bug report?
- Please check [issues](https://github.com/VFPX/Thor/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## New version
Here are the steps to updating to a new version:

* Make whatever changes are necessary.
* Edit _ThorVersion.h_ and change the version constants.
* Build _Thor_.app using VFP 9, not VFP Advanced, since the APP structure is different. Save the app in the parent folder of the Source folder; that is, in the Thor folder.
* Update the version number at the top of _README.md_ and describe the changes in the What's New section near the bottom.
* Update the AvailableVersion property in _ThorUpdater\\_ThorVersionFile.txt_: note the format of the value must be identical to the value of the `ccThorInternalVERSION` constant in _ThorVersion.h_.
* Update or recreate _ThorUpdater\Thor.zip_: it should contain the contents of the Thor folder; that is, the _Source_ folder and _Thor.app_.

## Update for Thor some projects
Some Thor based projects, for example **ThorRepository** maintain their version file inside this repository.   
There is nop need to do the steps above to update this information.   
Just:
- There is a zip _ThorUpdater\Updates.zip_.
- Unzip the file belonging to your project
- Change necessary information
- Tip to the same place inside the zip
- push

----
Last changed: _2022/04/01_ ![Picture](../Docs/Images/vfpxpoweredby_alternative.gif)