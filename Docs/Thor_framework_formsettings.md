FormSettings Object
===

This object allows forms to save their settings (size, position, and any other form properties) and align the form to the mouse or cursor position.

The FormSettings Object can be obtained from this single line of code, which is usually placed in a form’s Init method:

```loSettings = Execscript (_Screen.cThorDispatcher, 'class= ThorFormSettings', lxFormID)```

Where lxFormID is either

*   ThisForm (but only if called within an SCX)
*   or the name of the file to be used for saving settings (such as ‘GoToMethod.Settings’)

In order for this object to be used later (when the form closes), it must be saved as a form property:

    Thisform.AddProperty(‘oSettings’, loSettings)


### This object can then be used as follows:

Method|Meaning
---|---
.Restore(ThisForm)|Restores the saved settings for Top, Left, Height, and Width
.Restore(ThisForm, ‘propertylist’)|Restores the values for all properties named in {propertylist}, which is a character string of existing property names, delimited with commas.
.AlignToCursor(ThisForm, llAlignToMouse, tnVerticalAdjustment, tnHorizontalAdjustment)|Aligns the form (Top and Left properties) to the cursor position in the current edit window, if possible.  If the current window is not a edit window or llAlignToMouse = .T. , the form is aligned to the cursor position instead.
.Save(ThisForm)|Saves values of properties from the form so that they may be restored in the next session.  The properties that are saved are all those that had been restored with all calls to .Restore.  This call is usually made in the Form’s Destroy event


### Sample usage:

In the form’s ‘**Init**’ event:

#### [Click here for ThorFormSettings home page](Thor_framework_formsettings.md)


    loSettings) = ExecScript(_Screen.cThorDispatcher, "Class= ThorFormSettings", lxFormID)
    Thisform.AddProperty ('oSettings', loSettings)
    loSettings.Restore (Thisform) && Gets top, left, height, width
    loSettings.Restore (Thisform, 'nObjectType, cSearchString') && and two other properties

Where lxFormID is either

*   ThisForm (but only if called within an SCX)
*   or the name of the file to be used for saving settings (such as ‘GoToMethod.Settings’)

And in the form’s ‘**Destroy’** event:

    This.oSettings.Save (This)
    This.oSettings = .Null.```