Thor TWEeT #4: Insert full name of object under mouse
===

This week's TWEeT is **Insert full name of object under mouse** (the longer the tool name, the narrower it's focus)

This tool simplifies the task of inserting a reference to another object in the same form or class you are editing (VCXs / SCXs only).

The directions are simple:

1.  Place the cursor where you want the reference to be inserted in your code window. The focus must be on this method.
2.  Move the mouse over the object you want to refer to.
3.  Use the hot key you have assigned to **Insert full name of object under mouse.**

Two important parts of this to keep in mind:

1.  The focus must on the code window, not the form or class you are editing.
2.  This tool ***only works by using a hot key***, since it reads what is under the mouse when you execute it.

You may have problems with remembering so many hot keys (at least I do), particularly for tools like this that you might not be using with great regularity.  The way that I handle this is to add the tool to the [Thor Tool Bar](https://groups.google.com/forum/?fromgroups#!searchin/FoxProThor/toolbar/foxprothor/DvZMXuxIEwM/3NK3XnAFyqsJ). When I need it, the tooltip shows me the hot key.

This tool also works at run time. Place the cursor into the Command Window (instead of a code window) and the tool will paste into it a reference to the object under the mouse in an executing form.  

There is a closely related tool named **Inspect properties of object under mouse** (written by Andy Kramek) that also works at run time. Run this tool the same way and it pops up a MessageBox that displays the major properties of the object under the mouse.

Thor provides a neat tool for browsing the contents of objects and collections, **Object and Collection Inspector** -- more on that in next week's TWEeT.

_Tool written by Bernard Bout_

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
