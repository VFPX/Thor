Thor Form Usage Notes
===

There are a few very important considerations to keep in mind when using the Thor form:

* There are no 'Save', 'Cancel', or 'Undo' buttons on the form.  Any changes made on the form are posted to the underlying tables immediately, and there is no provision for canceling or un-doing any changes.

* When the form is opened, it reads the catalog of all tools and uses that catalog from there on.  Thus, changes made to tools, or tools that are added while the form is opened, are not automatically included in the catalog.  To synchronize the form with the catalog of all tools, use the Refresh button:

![](Images/Thor_Form_Usage_Notes_RefreshButton.png)

* Any updates made to the VFP system menu, pop-up menus, or hot key assignments are not applied until the form is closed.  To synchronize the VFP system menu, etc, with the form, use the Thor button:

![](Images/Thor_Form_Usage_Notes_ThorButton.png)