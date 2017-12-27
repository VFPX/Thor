The Thor Repository
===
<link rel="stylesheet" href="css/thortable.css">

The **Thor Repository** is a collection of IDE tools, accessible thru Thor, that have been written by members of the FoxPro community.

[**Download Thor Repository.Zip**]( http://vfpxrepository.com/dl/thorupdate/Tools/Thor_Repository/Thor_Repository.zip)

### Registering tools from the Thor Repository

The latest version of the Thor Repository is automatically downloaded and registered with Thor when you use the ‘Check for Updates’ option in the Thor menu (in the FoxPro system menu).  See [One-Click Updates of Thor](Thor_One-Cick_Update.md).

To manually register these tools with Thor, download them and save them in Thor's Tools sub-folder.

Feel free to modify and enhance them; if your enhancements or corrections are significant, please re-submit them.

To avoid losing any modifications you have made to these tools when you download a newer version of the Thor Repository, save any files you modify in your ‘My Tools’ sub-folder.  These files will never be over-written by any updates, and will take precedence over any tools in the Tools sub-folder  

**NOTE:** A majority of these tools require that PEM Editor 7 be installed and registered with Thor. However, they do **not** require that the PEM Editor form be open.  

### Submitting tools to be included in the Thor Repository

All FoxPro'ers are encouraged to submit IDE tools that they think would be of value to the FoxPro community at large (or, for that matter, to particular sub-sets of the FoxPro community).  

Tools can be submitted to this address:[**FoxProThor@googlegroups.com**](mailto:FoxProThor@googlegroups.com)  

Tools will be accepted into the Repository if they meet some minimum standards, which include:

*   They must act as designed and described.
*   They must have no undesirable side effects.
*   They must not make assumptions about file locations (such as folder names, other than system folders)
*   They must follow the standard Thor-Tool format for a PRG, and their description must be as complete as possible.

### Community Forum for Thor and Thor Tools

Please visit the community forum for Thor at [**http://groups.google.com/group/FoxProThor**](http://groups.google.com/group/FoxProThor) to make suggestions or comments, to report problems, and to see how others are using Thor and its related tools

## Thor Repository Tools

<!-- (new tools with this release are **Bold)** -->

Tool |Description|Updated|Video
:---|:---|:---|:---
||Code / Highlighted text
Comment highlighted text|Improved way to comment highlighted text; also creates comment line with date|2011/06/09
Un-comment highlighted text|Removes comment *!* from each line in the highlighted text. Works in those instances where native VFP uncomment does nothing.|2011/10/22
Wrap text with IF / ELSE / ENDIF|Wrap highlighted text with IF / ELSE / ENDIF|2011/10/22
Wrap text with Try / Catch|Wrap highlighted text with Try / Catch|2011/10/22
Change IF/ENDIF in highlighted text to DO CASE|Change the IF / ENDIF in the highlighted text to a Do Case / Otherwise / EndCase|2011/10/22
Break highlighted text|Break highlighted text out into a separate line|2011/10/22
Extract to Constant|Extracts the currently highlighted block of code into a new constant (#Define), either at the beginning of code or, for methods, into the Include file.  See also ‘Extract to Method’ in IDE Tools.|2011/10/22
Extract to Variable|Extracts the currently highlighted block of code into a new variable.  See also ‘Extract to Method’ in IDE Tools.|2011/10/22
Highlight parameter|Highlights a single parameter in a method or function call|2011/10/22
Highlight parentheses|Highlights code between matching parenthesis.  Repeated usage highlights the next outer set of parentheses.|2011/10/22
||**Code / Inserting text**
Insert blank lines around control structures|Adds a blank lines around control structures (IF / ENDIF, DO CASE / ENDCASE, etc.)|2011/10/22
Insert call to NewObject (from MRU classes)|Pops up menu of MRU classes; then pastes in NewObject() references to the selected class|2011/10/22
Insert color|Prompts for color, using GetColor(), and inserts RGB value|2011/07/29
Insert full name of object under mouse|Pastes the full path name of the object under the mouse into the code window.|2011/07/29
Insert reference to class|Inserts a reference to the class that an object belongs to; This.Parent.Parent, etc|2011/07/29
||**Code / MDots**
Add MDots to variable names|Adds MDots to all references to parameters, locals, and other variables assigned values.|2011/10/22
Remove MDots from variable names|Removes MDots from all references to parameters, locals, and other variables.|2011/10/22
||**Code / Misc.**
Install enhanced ZLOC|Installs an enhanced version of ZLOC, which will cause the pop-up list to also include all variables assigned in code, whether they are in the LOCALs list or not.  Note that this only need be done once, is it updates FoxCode.|2011/10/22
Modify Class for PRG-based classes|Provides a mechanism to convert a PRG based class (with no child objects) into a temporary VCX so that IDE Tools can work on it; and then post back again into the PRG|2011/10/22
||**Go To ...**
Go To ‘Find’ in PEM Editor|Sets focus to the ‘Find’ textbox in PEM Editor; opens PEM Editor if it is not already open|2011/10/22
Go To File|Opens a dialog with a filter box to quickly select a file (PRG, SCX, VCX, etc.) from the Active Project|2011/10/22
Go To Method|Opens a dialog form to choose a method to view or edit. Allows searching by part of a method name.|2011/06/03
Go To Object|Select the object which the method belongs to.|2011/07/29
||**Miscellaneous**
Display ClassLibs|Display current class libraries in a dialog box, one per line.|2011/06/03
Display Path|Display current path in a dialog box in a dialog box, one per line.|2011/06/03
HackCX4 from MRU forms or classes|HackCX: Pop-up menu to select a form or class (from MRU lists) to be opened with HackCX4|2011/06/03
Open Plug-Ins folder|Opens the folder for IDE Tools Plug-Ins|2011/10/22
Toggle comment colors|Toggle colors for comments in edit windows (normal vs. subdued)|2011/06/03
||**Projects**
MRU classes in this project|Popup menu of MRU classes in the current project|2011/06/04|[(1:56)](Thor_Repository_New_Repository_MRU_Projects.wmv)
MRU files in this project|Popup menu of MRU lists for files in the current project|2011/06/04|[(1:56)](Thor_Repository_New_Repository_MRU_Projects.wmv)
Open project folder|Open an Explorer folder showing the folder of the active project|2011/07/29
||**Samples**
Modify the “Last Revision” comment|Sample of finding a specific line in a edit window and modifying it.|2011/07/29
Wrap text with IF / ENDIF|Sample of taking the highlighted text in an edit window, modifying it, and pasting back the replacement.|2011/06/09
||**Tables**
Create SQL from cursor|Puts a CREATE CURSOR SQL statement on the clipboard from an open cursor.|2011/06/03
Schema|Print/View the current table's schema|2011/06/08
WLC Column Listing Utility|LIST FIELDS replacement by White Light Computing.|2011/06/03
||**Windows**
Cycle thru Designer windows|Cycle thru Form Designer and Class Designer windows|2011/06/03|[(3:33)](Thor_Repository_Repository_Windows_Management.wmv)
Move Designer windows to top|Move Form and Class Designers to top of screen and align them horizontally.|2011/06/03|[(3:33)](Thor_Repository_Repository_Windows_Management.wmv)
Resize Designer Window|Resize current Form / Class Designer window to show the entire form or class being edited.|2011/06/03|[(3:33)](Thor_Repository_Repository_Windows_Management.wmv)