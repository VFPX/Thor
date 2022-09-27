Thor TWEeT #9: Extract to Variable and Extract to Constant
===

In [last week's TWEeT](Tweet_08.md), I showed how you can highlight a block of text from a code window and save it into a new method.

There are two other closely related tools:

*   **Extract to Variable**
*   **Extract to Constant**

Use **Extract to Variable** to replace text in a line of code with a reference to a local variable, such as in this example where `laFileList[lnJ, 1]` is referenced a couple of times:

![](Images/Tweet9a.png)

The form that pops up allows you to enter the name of the new variable, whether all occurrences of the string are to be replaced (if not, only the highlighted one will be), and whether tool ‘Create Locals’ should be run to add this new variable to your LOCAL statements.

![](Images/Tweet9b.png)

The modified code looks like this:

![](Images/Tweet9c.png)

**Extract to Constant** works in a similar fashion, except that it creates a #Define statement either at the top of the current code window or in any of the #Include files that apply to the code window:

![](Images/Tweet9d.png)

I find that these three related tools, **Extract to Method / Variable / Constant**, to be of considerable value but I do not use any one of them often enough to assign hot keys to each of them.  Instead, I use a  [Popup Menu](../Thor_create_popup_menu.md), which I bring up by using a single hot key (I have chosen Ctrl+E, for “Extract”).

![](Images/Tweet9e.png)

There is a Thor tool to create this popup menu and a number of others.  Just execute **Create Sample menus** once and a number of menus will be created; see the first page of the Thor Configuration screen.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
