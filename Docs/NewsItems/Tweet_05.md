Thor TWEeT #5: _Object and Collection Inspector_
===

When working with Objects and Collections, it doesn't take long to realize that there's no easy way to view the structure or properties of an Object or browse the contents of a Collection.

The Watch window in the Debugger is a fair way to view an Object, of course, but there is simply nothing for viewing Collections.

To fill this void, Tamar created the **Object and Collection Inspector** (which you may already have seen described elsewhere).

Now the **Object and Collection Inspector** is a Thor tool, with considerable enhancement. As show below, it displays a TreeView showing all the children for an object, or the items in a collection, with the values for all the properties shown on the right.  Double-clicking a property opens a zoom box for editing its values.

![](Images/Tweet5a.png)

Run this tool as follows:

*   In a code window or the command window, click on the name of an object or collection and then call the tool.
*   Or, place the mouse over an object in an executing form, or a form or class being edited in the IDE, and call the tool.
*   Or, if a form or class is being edited, call the tool to inspect the currently selected object (that is, the one shown in the Property Sheet).
*   Otherwise, call the tool to paste text into the command window so that you can supply the name of the object or collection

**NOTE**: Unfortunately, because of the way this tool is invoked, it doesn't work from the Thor Tool Bar.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
