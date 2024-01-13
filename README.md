![](Docs/Images/Thor.png)  
## Tool manager for FoxPro

Version 1.47.02 Release 2024-01-13

[What's new in this release](Change%20Log.md)

_Requires VFP9_

***

_**Thor** is a tool for managing add-on tools in the IDE, managing menus and hot key assignments for IDE Tools._

[Get the latest Thor News](https://github.com/VFPX/ThorNews/blob/main/NewsItems/Archives.md)

**Getting Started:** [Click here for installation instructions](Docs/Thor_install.md)

**Help:** [Click here for complete online documentation](Docs/Thor_help.md)

**Discussions:** [Post questions, bug reports, discussions in the Thor Discussion Group](http://groups.google.com/group/FoxProThor)

**Tools for Thor: [PEM Editor w/IDE Tools](https://github.com/VFPX/PEMEditor),** **[The Thor Repository](Docs/Thor_repository.md)**, **[GoFish](https://github.com/VFPX/GoFish)** 

Thor:

*   has a user interface to control the assignment of hot keys to tools and developer-defined menus. The UI provides four different methods for accessing these tools:
    1.  By assigning hot keys to them
    2.  By creating pop-up menus accessible via hot keys
    3.  By adding them as bars under any of the VFP system pads (File, Edit, View, etc.)
    4.  By creating new pads in the VFP system menu and adding them as bars under these new pads
*   provides a unified method for registering tools.
*   simplifies the task of sharing them between developers.

Thor comes with a ready-made list of tools from two sources, the Thor Repository and PEM Editor. (See below)

Unlike the normal limited set of hot keys available from ON KEY LABEL, Thor provides for the full range of multiple-keystroke combinations ({Ctrl + Alt + A}, for instance). 

The 'tools' managed by Thor are simply PRGs with the following characteristics

*   The PRGs are named **Thor_Tool_*.PRG**
*   The PRG must be saved anywhere in the path, or in one of two Tools folders (which are created at installation) -- one for downloaded tools, one for personal tools.
*   The first 40 lines or so of the PRG must follow a fixed template, allowing Thor to query them as to their name, description, etc.

### Documentation

[Click here for complete online documentation of Thor](Docs/Thor_help.md)

### Getting Started

[Click here for installation instructions](Docs/Thor_install.md).

### Community Forum for Thor

Please visit the [Community Forum for Thor](http://groups.google.com/group/FoxProThor) to ask questions, make suggestions, report problems, and submit enhancement requests.  This is the best place to visit for all Thor-related topics.

### The Thor Repository

Inherent in the design of Thor is the anticipation that members of the FoxPro community will have utilities of value that can well be shared throughout the community. The structure of the tool PRGs make such sharing simple.  

The 'Thor Repository' is a catalog of such tools. The intent is that this repository grow over time, as developers submit tools to be included. The starting repository has about a dozen such tools. Click here for the help page for  [The Thor Repository](Docs/Thor_repository.md)  

Downloading and installation of the Thor Repository occurs automatically as part of the [One-Click Update for Thor](Docs/Thor_one-click_update.md)

### IDE Tools from PEM Editor

Version 7 of PEM Editor, now re-named 'PEM Editor w/ IDE Tools', contains more than three dozen tools that can be accessed through Thor. These include some tools released in version 6 of PEM Editor, along with a large number of completely new tools. These can be downloaded from the PEM Editor page. Click here for the help page for [Help page for PEM Editor w/IDE Tools](https://github.com/VFPX/PEMEditor)  

PEM Editor also "publishes" a pair of objects that simplify building further tools. More than half of the original tools in the Thor Repository use these objects.

Downloading and installation of PEM Editor 7 with IDE Tools occurs automatically as part of the [One-Click Update for Thor](Docs/Thor_one-click_update.md).

### Sample

Two new menu pads in VFP system menu (Thor and personal menu JRN) and the menu options in the Thor menu.

![](Docs/Images/Thor_image_4.png)

[What's new in this release](Change%20Log.md)

## Acknowledgments

*   The concept for this project started with Jim Nelson (the Project Manager).
*   The design was created by a group which included Doug Hennig, Eric Selje, and Tore Bleken.
*   The entire UI was designed and implemented by Doug Hennig.

----
## Helping with this project
See [How to contribute to Thor](.github/CONTRIBUTING.md) for details on how to help with this project.

![Picture](Docs/Images/vfpxpoweredby_alternative.gif)