ContextMenu Object
===

This object provides a simple mechanism for creating pop-up context menus.

It can be obtained from this single line of code:

    loContextMenu = Execscript (_Screen.cThorDispatcher, 'class= Contextmenu')

Items are added using the .AddMenuItem method, sub-menus are created by using the AddSubMenu / EndSubMenu pair, and the menu is activated with the Activate method.

The parameters to AddMenuItem allow you to define either a string to execute or a keyword/parameter pair which can be processed after the Activate method, allowing all processing to be contained in a single method.  See the last example.

This object can then be used as follows:

Method|Meaning|
---|---
.AddMenuItem(lcPrompt, lcExec, lcStatusBar, lcKeyStroke, lcKeyWord, lxParameters)|lcPrompt. Prompt for the menu Item
.AddMenuItem parameter|lcExec|String to be executed.  This may be empty, in which case lcKeyword and lxParameters are used.
.AddMenuItem parameter|lcStatusBar|Text to be displayed on the status bar
.AddMenuItem parameter|lcKeyStroke|Keystroke
.AddMenuItem parameter|lcKeyword|Keyword which will be available from the object if this item is chosen (relevant only if lcExec is empty)
.AddMenuItem parameter|lxParameters|Other parameters which will me made available from the object if this item is chosen (relevant only if lcExec is Empty)
.AddMenuItem parameter|Note that a separator bar can be created by calling AddMenuItem with no parameters
.AddSubMenu(lcPrompt)|Begins definition of a submenu.  All calls to AddMenuItem until the call to the closing EndSubMenu will be in this submenu.  May itself contain a submenu
.EndSubMenu|Marks the end of a submenu.
.Activate|Activates the pop-up menu.  If the item selected had an empty value for lcExec, returns an integer indicating the item selected.  In this case, loContextMenu.Keyword returns the value for lcKeyword for the selected item, and similarly for loContextMenu.Parameters


### \* Sample 1: simple menu, two choices
```foxpro
loContextMenu = Execscript (_Screen.cThorDispatcher, 'class= Contextmenu')  
With loContextMenu  
    .AddMenuItem ('Item 1', [MessageBox('Item 1')])  
    .AddMenuItem ('Item 2', [MessageBox('Item 2')])  
    .Activate()  
Endwith
```
 
### \* Sample 2: sub-menus
 
```foxpro
loContextMenu = Execscript (_Screen.cThorDispatcher, 'class= Contextmenu')  
With loContextMenu  
    .AddMenuItem ('Item 1', [MessageBox('Item 1')])  
    .AddMenuItem ('Item 2', [MessageBox('Item 2')])
 
    .AddSubMenu ('SubMenu 1')  
    .AddMenuItem ('Item 1-1', [MessageBox('Item 1-1')])  
    .AddMenuItem ('Item 1-2', [MessageBox('Item 1-2')])  
    .EndSubMenu()

    .AddSubMenu ('SubMenu 2')  
    .AddMenuItem ('Item 2-1', [MessageBox('Item 2-1')])  
    .AddMenuItem ('Item 2-2', [MessageBox('Item 2-2')])  
    .EndSubMenu()

    .Activate()  
Endwith
```

### \* Sample 3:  Instead of passing something to execute for each menu item, a keyword is associated with each item.  If .Activate() returns .T., the keyword for the selected item is available to be used in the following code.

```foxpro
loContextMenu = Execscript (_Screen.cThorDispatcher, 'class= Contextmenu')  
With loContextMenu  
    .AddMenuItem ('Item 1', , , , 'This is the first item')  
    .AddMenuItem ('Item 2', , , , 'This is the second item')  
    If .Activate()  
        lcKeyword = .KeyWord  
        Messagebox (lcKeyword)  
    Endif  
Endwith
```
