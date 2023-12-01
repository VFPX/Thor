# How to contribute to Thor

## Bug report?
- Please check [issues](https://github.com/VFPX/Thor/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## New version
Here are the steps to updating to a new version:

1. Create a fork at github
   - See this [guide](https://www.dataschool.io/how-to-contribute-on-github/) for setting up and using a fork.
   - See [Forking / Testing](#forking-testing) for advice to do independent testing.
2. Make whatever changes are necessary.

**Steps 3 through 10 only apply if you intend to merge your changes immediately into the master repository for Thor. This can only happen if you have access to do so and you are sure that your changes do not need any further testing by others.**

*If you do not intend to merge into the master repository or are in any way unsure what this means, skip directly to step 11.*

---
#### If updating Thor.App
3. Edit _Installed Files\Source\ThorVersion.h_ and change the version constants.
1. Update the AvailableVersion property in _ThorUpdater\\_ThorVersionFile.txt_. Be certain that the value be identical to the value of the `ccThorInternalVERSION` constant in _ThorVersion.h_.
1. Update the version number and date at the top of _README.md_.
1. Describe the changes in _Change Log.md_, set the date on the footer to recent date.
1. Run FoxBin2Prg to create the text files in folder _Installed Files_
   - `DO foxbin2prg.prg WITH 'BIN2PRG','*.*'`
1. Run _BuildThor.PRG_ in folder _"Installed Files\Source"_ to re-create the APP. You will need to do this in an environment where Thor is no longer running:
    - `Cancel()`
    - `Close All`
    - `Clear All`
    - `Release All`
---
#### If updating version info for VFPX Projects / CFU (most projects) or creating an updater for a new projects
---

This applies to all updaters except those few (15 or so) where the version information is read from a separate URL (.VersionFileURL) which is normally used only for projects with continuing updates.

9. Add / Modify the prg file in Updaters\Updates

---
### Finally
10. In folder _ThorUpdater_, right-click _CreateThorUpdate.ps1_ and select **Run with PowerShell** from the shortcut menu to re-create the installation zip files.
11. Commit
12. Push to your fork
13. Create a pull request

### Forking / Testing
If you consider to do an independent test of your fork (or run your fork for your needs), you might want to alter the repository or the branch of Thor or [ThorRepository](https://github.com/VFPX/Thorrepository).
Repository and branch determine the URL.

The URL to a file on github comes in a form `https://github.com/VFPX/Thor/blob/master/Docs/TWEeTs.md`,
where `VFPX/Thor` is a *repository* (Thor) and *project* (VFPX), and `master` is the *branch*.   
DEFINES are used to access those in several files. Alter the DEFINES to your repository and branch.

#### Common helper project
To keep the files to target a change of URL together, there is an otherwise useless project: Thor_Help.pjx.
Compile this to force changes to the DEFINE into the code.

#### Redirect Thor
You might redirect the web access from the main repository. To do so alter in:   
- installed files\source\thor.h
- updaters\updates\thor_update_thor.prg
```
#Define     ccThor_URL               'VFPX/Thor'
#Define     ccThor_Branch            '/master'
```
**Note, the leading slash on `ccThor_Branch` is mandatory.**

The following files are touched by this DEFINES and must be compiled if the DEFINE is altered. Use the [helper project] (#common-helper-project) to compile.
- installed files\source\procs_for_thor\thor_proc_check_for_updates.prg
- installed files\thor\tools\procs\thor_proc_check_for_updates.prg
- installed files\thor\tools\thor_tool_thorchangelog.prg
- installed files\thor\tools\thor_tool_thorinternalframeworkhelp.prg
- installed files\thor\tools\thor_tool_thorinternalhelp.prg
- installed files\thor\tools\thor_tool_thorinternalrepositoryhomepage.prg
- installed files\thor\tools\thor_tool_thorinternaltweets.prg
- updaters\updates\thor_update_thor.prg
- installed files\source\thor_run.vcx
- installed files\source\thorformruntool.scx

#### Redirect ThorRepository
You might redirect the web access from the main repository. To do so alter in:   
- installed files\source\thor.h
- updaters\updates\thor_update_thorrepository.prg
```
#Define     ccThorRepository_URL     'VFPX/ThorRepository'
#Define     ccThorRepository_Branch  '/master'
```

**Note, the leading slash on `ccThorRepository` is mandatory.**

The following files are touched by this DEFINES and must be compiled if the DEFINE is altered. Use the [helper project] (#common-helper-project) to compile.
- updaters\updates\old_thor_update_thor_repository.prg
- installed files\source\thor_update_thor_repository_beta.prg
- updaters\updates\thor_update_thorrepository.prg

----
Last changed: _2023/12/01_ ![Picture](vfpxpoweredby_alternative.gif)
