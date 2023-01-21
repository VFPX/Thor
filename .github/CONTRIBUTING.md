# How to contribute to Thor

## Bug report?
- Please check [issues](https://github.com/VFPX/Thor/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## New version
Here are the steps to updating to a new version:

1. Create a fork at github
   - See this [guide](https://www.dataschool.io/how-to-contribute-on-github/) for setting up and using a fork
2. Make whatever changes are necessary.
---
#### If updating Thor.App
3. Edit _Installed Files\Source\ThorVersion.h_ and change the version constants.
1. Update the AvailableVersion property in _ThorUpdater\\_ThorVersionFile.txt_. Be certain that the value be identical to the value of the `ccThorInternalVERSION` constant in _ThorVersion.h_.
1. Run _BuildThor.PRG_ in folder _"Installed Files\Source"_ to re-create the APP. You will need to this in an environment where Thor is no longer running:
    - `Cancel()`
    - `Close All`
    - `Clear All`
    - `Release All`
1. Run FoxBin2Prg to create the text files in folder _Installed Files_
   - `DO foxbin2prg.prg WITH 'BIN2PRG','*.*'`
1. Update the version number and date at the top of _README.md_ 
1. Describe the changes in _Change Log.md_.
---
#### If updating Thor News
---
9. Increment the news version number in _Docs/NewsItems/ThorNewsVersion.txt_.
1. Create the new item as _Docs/NewsItems/Item_NN.txt_.
1. Paste the new item into _Docs/Thor_News.txt_, replacing the current (top) item there
1. Add a line at the top of "Headline History" in _Docs/Thor_News.txt_ with a link to the new item.
---
#### If updating version info for VFPX Projects / CFU (most projects)
---

This applies to all updaters except those few (15 or so) where the version information is read from a separate URL (.VersionFileURL) which is normally used only for projects with continuing updates.

13. Add / Modify the prg file in Updaters\Updates

---
### Finally
14. In folder _ThorUpdater_, right-click _CreateThorUpdate.ps1_ and select **Run with PowerShell** from the shortcut menu to re-create the installation zip files.
1. Commit
1. Push to your fork
1. Create a pull request


----
Last changed: _2023/01/21_ ![Picture](vfpxpoweredby_alternative.gif)
