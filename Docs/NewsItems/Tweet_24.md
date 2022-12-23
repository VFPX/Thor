Thor TWEeT #24: New Thor Tools
===

There are nine new tools that have been added in the last month to the Thor Repository:

*   _[Pack VCXs, SCXs, etc. from a project or folder](#T1)_
*   _[Hack Intellisense](#T2)_
*   _[Dropdown Intellisense Scripts](#T3)_
*   _[Keyboard Macro Expansion](#T4)_
*   _[Create SQL Data Dictionary](#T5)_
*   _[Browse SQL Data Dictionary](#T5)_
*   _[MRU Tables](#T9)_
*   _[Toggle PEM Editor Event Handler](#T8)_
*   _[Toggle Debugger](#T7)_

### <a name="T1"></a>Pack VCXs, SCXs, etc. from a project or folder

The new tool _Pack VCXs, SCXs, etc. from a project or folder_ prompts for a project/folder and then packs all the X-files found in that project/folder.

You can bypass the prompts by invoking the Thor procedure directly:

[1]  To pack files in the current project:

```foxpro
lcOption = ExecScript(_Screen.cThorDispatcher, 'Thor_Proc_PackProject', .T.)
```

[2]  To pack files in a specific project:

```foxpro
lcOption = ExecScript(_Screen.cThorDispatcher, 'Thor_Proc_PackProject', cProjectName)
```

[3]  To pack files in a specific folder:

```foxpro
lcOption = ExecScript(_Screen.cThorDispatcher, 'Thor_Proc_PackProject', cFolderName)
```


### <a name="T2"></a>Hack Intellisense

The new tool _Hack Intellisense_ provides an extremely usable alternative to the native Intellisense Manager (shown below) for working with your custom Intellisense scripts.

![](Images/Tweet24a.png)

I always found the Intellisense Manager page to be remarkably opaque, to the point where I simply gave up trying to add any new scripts to it. 

The tool _Hack Intellisense_ provides a different UI to update your FoxCode table, making everything much clearer. It also provides a number of niceties, including:

*   Filtering by text or type of script (I suggest trying "User" filter)
*   Sorting
*   Buttons to duplicate or remove a script.
*   Buffering of your changes, so that you can commit or revert as desired
*   Backing up of your FoxCode table.
*   Customizable signature
*   "Edit" and "Test" buttons for your more intricate code (in field "data")

![](Images/Tweet24b.png)

In the short time that this tool has been available, I have already found that I am taking advantage of these custom scripts much more frequently.

There are also plans of enhancing _Hack Intellisense_ to facilitate sharing of scripts that we have each created over time. I will keep you posted of any developments.

Note also a related tool, _DropDown Intellisense Scripts_, announced last week, which helps you find and use scripts you have created without using this form.

_Hack Intellisense_ was written by Rick Schummer, with some tweaks by Todd Landrum and myself.

### <a name="T3"></a>Dropdown Intellisense Scripts

Announcing a new tool, _Dropdown Intellisense Scripts_, to help you find and use Intellisense scripts created using the Intellisense Manager or the new tool _Hack Intellisense_ .

This tool works like a number of other "Dropdown" tools as part of IntellisenseX.  It provides a drop-down list of all of the native Intellisense scripts (including any you have added).  

The filtering applies not only to the script abbreviation ("TGO" in the example below) but also its description (if any). 

Selecting any item from the list will cause that item to be expanded, just as normal Intellisense would have expanded it.

There's also a new wrinkle here -- this works anywhere in a text line, unlike normal Intellisense, which only works at the beginning of a line.

![](Images/Tweet24c.png)

### <a name="T4"></a>Keyboard Macro Expansion

The new tool _Keyboard Macro Expansion_ is an extension to native Intellisense. Native Intellisense expands custom scripts, but only at the beginning of a line of code in the command window or code window.

Thus, when I type **TGO** (one of my custom Intellisense scripts) into the command window and follow it by a space, it is expanded by Intellisense to:

```foxpro
ExecScript(_Screen.cThorDispatcher, 'Get Option=', 'KEY', 'TOOL')
```

The new tool _Keyboard Macro Expansion_ also expands Intellinsense scripts, but is not limited to doing so at the beginning of a line.

If I enter the following:

```foxpro
lcOption = TGO
```

and then call this new tool (which I have assigned to the hot key Ctrl+I), it expands to:

```foxpro
lcOption = ExecScript(_Screen.cThorDispatcher, 'Get Option=', 'KEY', 'TOOL')
```
(This works by reading the same definitions from the FoxCode table as used by native Intellisense.)

There is a second extension, provided in the plug-in for  _Keyboard Macro Expansion_ (see [Plug-Ins](../Thor_add_plugins.md)). The plug-in provides an alternative to the FoxCode table so that you can programmatically evaluate the word that is to be substituted for and replace it as desired.  The sample code in the plug-in demonstrates how

```foxpro
loAnything
```
becomes

```foxpro
Local loAnything as Anything of Anything.prg
```
### <a name="T5"></a>Create SQL Data Dictionary

### <a name="T6"></a>Browse SQL Data Dictionary

IntellisenseX and Super Browse can both access field names from SQL Tables, as described in  [Thor TWEeT 10](Tweet_10.md).

The natural way to access these field names is to use a connection string to access the SQL Server database.

Alternatively, you can create an  [SQL Dictionary](Tweet_10.md#SQLDictionary) that contains the names of all tables and their fields, and IntellisenseX will use those field names even if the SQL database is not available. 


The name of the SQL Data Dictionary is entered in the Thor configuration form (and note the typo!)

![](Images/Tweet24d.png)

### <a name="T9"></a>MRU Tables

The new tool _MRU Tables_ provides a dropdown list of MRU tables; the selected table is opened with _Super Browse._

Note that all Thor tools that open tables (including _Super Browse_, _Go To Definition_, and others) add any table that they open to the system MRU list for tables

This MRU dropdown list is also available from the right-click context menu of the “File Search” command button in _Finder_.

![](Images/Tweet24e.png)

### <a name="T8"></a>Toggle PEM Editor Event Handler

PEM Editor, if open, provides design time event handing. The most familiar use is evaluating the Anchor properties when resizing controls so that a form or class resizes as it would at run time. See the PEM Editor help file for more on this.

### <a name="T7"></a>Toggle Debugger

Nothing magic about this one, other than it’s handy to have a single tool that is available on a hot key.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
