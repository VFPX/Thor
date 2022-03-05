# How to contribute to Thor

## Bug report?
- Please check [issues](https://github.com/VFPX/Thor/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## New version
Here are the steps to updating to a new version:

* Make whatever changes are necessary.
* Edit ThorVersion.h and change the version constants.
* Build Thor.app using VFP 9, not VFP Advanced, since the APP structure is different. Save the app in the parent folder of the Source folder; that is, in the Thor folder.
* Update the version number at the top of README.md and describe the changes in the What's New section near the bottom.
* Update the AvailableVersion property in ThorUpdater\_ThorVersionFile.txt: note the format of the value must be identical to the value of the ccThorInternalVERSION constant in ThorVersion.h.
* Update or recreate ThorUpdater\Thor.zip: it should contain the contents of the Thor folder; that is, the Source folder and Thor.app.
