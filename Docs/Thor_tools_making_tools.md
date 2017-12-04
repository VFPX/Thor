The Thor Framework: tools to make tools
===

Thor provides a framework of tools to assist in creating tools.

Each of the tools in the framework can be obtained from a single line of code that looks like this:

    Result = Execscript (_Screen.cThorDispatcher, cParameter)

This rather unusual approach was chosen because it achieves two goals:

1.  The tools in the framework are available with only the single dependency (the name of the property in _Screen) and thus can be accessed by tools regardless of the folder where Thor is installed.
2.  The tools in the framework are available even after a ‘Clear All’.

Note that the tools in the framework are always available from the Thor menu in the VFP system menu, and you can copy the line of code to access the tool directly from there.  Furthermore, if available, there is access to the home page for the tool.

![](Images/Thor_Tools_Making_Tools_image_2.png)

### External APPs:

The structure of Thor provides for the inclusion of other objects embedded in APP files.  In particular are these two, developed as part of PEM Editor.  

**cParameter** |**Result**
---|---
Class= editorwin from pemeditor|Methods to access and modify the text in the currently open editing window (Select, Cut, Copy, Paste, etc ...)  - see [Thor EditorWindow Object](Thor_editorwindow_object.md)/
Class= tools from pemeditor|A collection of various methods, not related to each other, but of value beyond their use in PEM Editor – see [Thor Tools Object](Thor_tools_object.md)


### Internal Tools:

**cParameter** |**Result**
---|---
Class= ContextMenu|Returns an object used to create context menus - see [Thor ContextMenu](Thor_framework_contextmenu.md)
Class= ThorFormSettings|Returns an object so that forms can save their settings (size, position, etc) and align the form to the mouse or cursor position – see [Thor FormSettings](Thor_framework_formsettings.md)
Class= FindEXE|(documentation not yet available)
Tool Folder=|Returns the name of Thor’s tool folder
Thor Register=|Returns an object so that an APP can self-register its own tools, such as is done by [GoFish 5](https://github.com/mattslay/GoFish) and [PEM Editor 7](https://github.com/VFPX/PEMEditor).
Run|Runs Thor.  Same as  Do Thor with ‘Run’  or  Do RunThor
Edit|Opens Thor form.  Same as Do Thor with ‘Edit’
Clear HotKeys|Removes all Thor-assigned keyboard macros so that a macros (FKY) file can be saved

### See also

*   [Browsing the list of tools](Thor_browsing_tools.md)
*   [Assigning hot keys to tools](Thor_assign_tool_hot_keys.md)
*   [Editing existing tools](Thor_editing_existing_tools.md)
*   [Creating new tools](Thor_creating_new_tools.md)

