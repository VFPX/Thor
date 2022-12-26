**New Thor Tools and [SuperBrowse](..\Thor_superbrowse.md) Enhancements** 
---

### #42, 2015-11-30

A number of new Thor tools are available in the Thor Repository.

*   'Toggle tabs in pageframe' – It can be quite difficult (OK, cumbersome) to navigate between pages of a pageframe when the tabs are not visible.  Use this tools to toggle the tabs in the current pageframe.
*   'Compare text in two windows' – Use your favorite compare tool to compare the code from two different code windows without exiting FoxPro, as follows:
    *   Select one text window
    *   Execute this tool (hot key is recommended)
    *   Select a second text window
    *   Execute this tool again  
            -- and the contents of the two windows will be compared

> **Required:**  Thor cannot guess your favorite compare tool, so you must modify the Plug-In so that Thor can call it. The default code for the Plug-in calls Beyond Compare (_personal note: highly recommended!)_ and must be modified to fit your environment.

*   Three new tools for [VFP2Text](http://pfsolutions-mi.com/Product/VFP2Text), a add-on from Frank Perez, Jr. for Beyond Compare, that allow direct comparison of VCXs and SCXs
    *   'Download VFP2Text for Beyond Compare V3'
    *   'Download VFP2Text for Beyond Compare V4'
    *   'VFP2Text Home Page'

There have been some enhancements to **[SuperBrowse](..\Thor_superbrowse.md)** as well:

*   As it can be quite cumbersome switching between Expression and Value in the filter box, you can now overwrite the current setting as follows:
    *   To select Value, use a trailing ‘$’
    *   To select Expression, use a leading ‘=’
*   "Value" filters on all selected fields or, if none, all character fields.
*   Double-clicking a row (to edit using Dynamic Forms) brings up a read-only form if the table is read-only.
*   A new setting allows leading characters from memo fields to be displayed instead of "Memo".
*   Double-clicking a memo fields brings up that field alone for editing.
*   There are a number of new plug-ins:
    *   Format field picker -- create alternative formats to those provided on the first page ("Picker") to conform to your own preferences
    *   Bind column events -- bind events in the grid columns to this class
    *   Grid context menu -- create context menus for the cells in the grid  


---
See also [Thor News](../Thor_news.md) and the [Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).  
