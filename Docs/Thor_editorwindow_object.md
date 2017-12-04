Thor EditorWindow Object
===

All of the IDE features of PEM Editor which access and / or modify the text in the currently open editing window use the functions from **FoxTools.fll**.

The Thor EditorWindow Object is made available to make it simple to build Thor tools which can also access or modify the text in the currently open editing window.  This object serves two purposes:

1.  It provides wrapper methods for the most useful functions in **FoxTools.fll**.
2.  When accessed, it has already determined the handle for the current editing window.  All of its methods reference this handle, eliminating the need for the handle to be otherwise known or referenced.

The Thor EditorWindow Object can be obtained from this single line of code:

```foxpro
loEditorWin = Execscript (_Screen.cThorDispatcher, 'class= editorwin from pemeditor')
```


Some further notes:

1.  Character positions and line counts start at 0, not 1\. (i.e., be careful)
2.  While this object only is available if PEM Editor has been installed, the PEM Editor form itself need not be open for it to work.
3.  There are numerous uses of this object in the tools in the Thor Repository.

### Window manipulation: handles, size, position, title, etc.

Methods (Parameters)|Description
---|---
CloseWindow()|Close the current window
FindLastWindow()|Returns the handle of the most recently used window which is either of a PRG or method code from the Form or Class Designer.
FindWindow() |Saves the handle for the currently active window, and returns its window type:
FindWindow() return value x|x=0: Command Window, Form and Class Designers, other FoxPro windows|
FindWindow() return value x|x=1: Program file (MODIFY COMMAND)|
FindWindow() return value x|x=2: Text Editor (MODIFY FILE)|
FindWindow() return value x|x=8: Menu code edit window|
FindWindow() return value x|x=10: Method code edit window of the Class or Form Designer
FindWindow() return value x|x=12: Stored procedure in a DBC (MODIFY PROCEDURE)
FindWindow() return value x|x=-1: None
GetHeight()|Returns the height of the editing window, in pixels.
GetLeft()|Returns the left position of the editing window, in pixels.
GetOpenWindows()|Returns a collection of the handles of all open windows, most recently used first.
GetTitle()|Returns the title for the current window
GetTop()|Returns the top position of the editing window, in pixels.
GetWidth()|Returns the width of the editing window, in pixels.
GetWindowHandle()|Returns the handle of the current editing window
MoveWindow (tnLeft, tnTop)|Moves the editing window to position {tnLeft}, {tnTop}. Both are in pixels.
ResizeWindow (tnWidth, tnHeight)|Resizes the editing window to {tnWidth} by {tHeight}. Both are in pixels.
SelectWindow (tnHandle)|Selects (brings to the foreground) window with handle {tnhandle}
SetHandle (tnHandle)|Sets the handle (used to indicate the window being referenced in most of these commands)
SetTitle (tcNewTitle)|Sets the title for the editing window to {tcNewTitle}


### Text manipulation

Methods (Parameters)|Description|
---|---
Copy()|Copies the currently highlighted text into the clipboard
Cut()|Cuts the currently highlighted text
EnsureVisible (tnPosition, tlScroll)|Ensures that the character at position {tnPosition} is visible in the editing window. If {tlScroll} is true, it is brought to the mid-point of the editing window
GetCharacter (tnPosition)|Returns the character at position {tnPosition}
GetEnvironment {tnIndex}|Returns a single environment setting. {tnIndex} takes values from 1 to 25\. See _EdGetEnv in the help for FoxTools for a description of all the settings. Frequently used values are:
GetEnvironment {tnIndex} Return value x|x=2: File Size
GetEnvironment {tnIndex} Return value x|x=17: Selection start
GetEnvironment {tnIndex} Return value x|x=18x: Select end
GetEnvironment {tnIndex} Return value x|x=25: Window Type
GetFileSize()|Returns the file size
GetLineNumber (tnSelStart)|Returns the line number for the character at position {tnPosition}
GetLineStart (tnSelStart, tnLineOffset)|Determines the line number for the character at position {tnPosition} and returns the position for the character at the beginning of that line. If {tnLineOffset} is supplied, it first offsets the line number by that amount. Thus .GetLineStart (tnSelStart, 1) gives the start position of the next line after the line for {tnSelStart}
GetSelEnd()|Returns the position for the end of the currently highlighted text
GetSelStart()|Returns the position for the start of the currently highlighted text
GetString (tnSelStart, tnSelEnd)|Returns the string of characters from position {tnSelStart} through {tnSelEnd}
Paste(tcText)|If {tcText} is supplied, pastes it into the editing window, leaving _ClipText unchanged.  Otherwise, pastes the contents of the clipboard into the editing window.
Select (tnSelStart, tnSelEnd)|Selects (highlights) the string of characters from position {tnSelStart} through {tnSelEnd}
SetInsertionPoint (tnPosition)|Sets the insertion point to {tnPosition}
