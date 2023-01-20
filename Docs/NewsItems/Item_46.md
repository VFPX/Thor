**Two New Thor Tools: "Execute Selected Text" and "Highlight Current Statement"** 
---

### #46, 2023-01-20

#### Tool "Execute Selected Text" ####

This tool is an extension of the familiar option in the context menu when editing code:

![](Images/Item_46_ExecuteSelection.png)

The tool provides three new features:

1. If NO text is selected, the entire (possibly multiple line) statement is highlighted and executed.  The cursor can be anywhere in any line of the statement.  In other words, click somewhere in the statement and run the tool to execute the statement.

1. All defined constants will work (instead of failing as they do when using the context menu).  That means all defined constants from #Define or #Include directives as well as the include files from VCXs and SCXs. Note, for example, the use of CR in the image above.

1. A plug-in is provided for you to handle the selected text; you might save it in the clipboard or some history file.

In addition, since this is a Thor tool, a hot key can be assigned to it, replacing the slightly more cumbersome use of the context menu.

#### Tool "Highlight Current Statement" ####

This tool is used to highlight an entire (possibly multiple line) statement.  The cursor can be anywhere in any line of the statement. Just as described above, click somewhere in the statement and run the tool to highlight the statement.

---
See also [Thor News](../Thor_news.md) and the [Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).  
