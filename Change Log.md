# Thor Change Log

### Thor 1.45.28 - Released 2023-08-05

* Add new tool "Browse Hot Keys" to Thor menu pad
* For CFU, clean up event logging and create new folder in Sys(2023)

### Thor 1.45.27 - Released 2023-07-22

* Extensive refactoring to ease the issue of releasing modifications to core programs for CFU
* Re-arrangement of "Thor" menu items
* New property "Dependencies" in Updater/Version file where one project requires another.
* New pop-up menu for help and other features when pressing Ctrl when selecting a menu item from a Thor menu

### Thor 1.45.26 - Released 2023-06-21

Enhanced error reporting for errors during downloading and installing projects in "Check For Updates".

### Thor 1.45.25 - Released 2023-06-11

Revert code that re-opened projects after CFU; caused failure "too many dos"

### Thor 1.45.24 - Released 2023-06-10

Tweaks to Property used in _Screen

# Thor Change Log

### Thor 1.45.21 - Released 2023-05-20

Favorites now appear in bold for menu items from the system menu or popup menus

### Thor 1.45.19 - Released 2023-04-08

* Two bug fixes
* Add 'Project Type" column to CFU form

### Thor 1.45.17 - Released 2023-04-06

* Modified menu options in system menu pad for Thor, adding "Project Home Pages"
* Changed handling of Thor News to use new location in https://github.com/VFPX/ThorNews

### Thor 1.45.16 - Released 2023-04-02

Enable sorting on most of columns in CFU form.

### Thor 1.45.15 - Released 2023-04-02

Fix to issue where CFU form position not handled properly in multiple monitor situation

### Thor 1.45.14 - Released 2023-03-24

Bug fix in 1.45.11&12&13

### Thor 1.45.11 - Released 2023-03-23

References to installed Thor tools using explicit full paths are replaced with uses of _Screen.cThorFolder so that that are relocatable

### Thor 1.45.10 - Released 2023-03-21

Fix to problem where Check For Updates screen does not come up in visible screen

### Thor 1.45.09 - Released 2023-03-19

Fix bad links in Framework

### Thor 1.45.07 - Released 2023-01-20

Separated version number and date into distinct columns into CFU grid.

### Thor 1.45.06 - Released 2023-01-20

Re-arrangement of options in the Thor menu pad in system menu, including hot key assignments.

### Thor 1.45.05 - Released 2023-01-13

New Updater property to indicate that a project is to be installed in the Tools folder instead of a sub-folder of Tools\Apps or Tools\Components.

### Thor 1.45.04 - Released 2023-01-06

Changes to Thor menu pad in VFP system menu
* Remove outdated/irrelevant menu items
* Correct links to Forums
* For "Thor Framework", ignore errors for file not found (bad links, essentially)
* Correct links to Change Logs

### Thor 1.45.03 - Released 2022-12-26

Thor News back in business.

### Thor 1.45.01 - Released 2022-12-13

Added ability to move or delete separator lines in menus in Thor Configuration form.

### Thor 1.45 - Released 2022-03-05

Updated the Check for Updates process to log unzipping failure.

### Thor 1.44 - Released 2022-03-04

Updated the Check for Updates process to use Shell.Application instead of VFPCompression to unzip files.

### Thor 1.43 - Released 2021-12-28

Updated the Check for Updates process to look at the GitHub repository of each project rather than VFPXRepository.com.

### Thor 1.40 – Released 2013-08-26

Added the Thor ToolBar.  Tools may be added to the Toolbar may using the checkbox shown in the Thor Configuration form,  below (and also available in the [Tool Launcher](Docs/Thor_launcher.md).)

![](Docs/Images/Thor_SNAGHTMLf389404.png)

When you add a tool to the Thor Toolbar, you can select a caption for the tool or select an image to represent it.  In the sample below, abbreviated captions are used.

![](Docs/Images/Thor_SNAGHTMLf3b4e2e.png)

The toolbar’s size, positioning, and docking, persist from one session to the next. (Truth be told, persisting the docking has been problematic.)

### Thor 1.30 – Released 2012-08-19

*   Added [Tool Launcher](Docs/Thor_launcher.md), available from the Thor menu in the VFP system menu

![](Docs/Images/Thor_SNAGHTML39362d.png)

*   Added [Thor IntellisenseX](https://github.com/VFPX/IntelliSenseX).

![](Docs/Images/Thor_image_2.png)

### Thor 1.1 - Released 2011-10-23  

Thor Production Release - Released 2011-09-03  

### Thor I Beta 6 - Released 2011-08-22 (88 downloads)

*   a few minor bug fixes

### Thor I Beta 5 - Released 2011-08-09 (91 downloads)

*   Miscellaneous minor adjustments and a couple of bug fixes

### Thor I Beta 4 - Released 2011-07-17 (125 downloads)

*   Re-installation now occurs automatically. Simply using the new version of Thor.App will cause re-installation.
*   Includes full online documentation.

### Thor I Beta 3 - Released 2011-07-06 (94 downloads)  

### Thor I Beta 2 - Released 2011-07-04 (61 downloads)  

### Thor I Beta - Released 2011-06-03 (237 downloads)

## Acknowledgments

*   The concept for this project started with Jim Nelson (the Project Manager).
*   The design was created by a group which included Doug Hennig, Eric Selje, and Tore Bleken.
*   The entire UI was designed and implemented by Doug Hennig.

----
## Contribution
See [contribution](./.github/CONTRIBUTING.md)

Last changed: _2023/01/20_ ![Picture](Docs/Images/vfpxpoweredby_alternative.gif)