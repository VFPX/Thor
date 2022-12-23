Thor TWEeT #21: Advanced Features: Plug-Ins for [IntellisenseX](https://github.com/VFPX/IntelliSenseX)
===

There are five [Plug-Ins](../Thor_add_plugins.md) that provide the last type of customization available for [IntellisenseX](https://github.com/VFPX/IntelliSenseX).  Even though they may seem quite obscure at first, they can each provide quite powerful enhancements, far beyond what you might first expect.  Some personal examples are provided to illustrate how they can be used (although these examples are certainly not the only way they can be used).

To access them, follow these steps:

1.  Open Tool Launcher
2.  Enter “IntellisenseX” in the filter box
3.  Click on the tool “IntellisenseX – by Dot” in the TreeView on the left.
4.  Click on the Plug-Ins link to open the Plug-Ins Form.

![](Images/Tweet21a.png)

The Plug-Ins form (when accessed this way) shows only those Plug-Ins that apply to IntellisenseX:

![](Images/Tweet21b.png)

There is no natural order to these Plug-Ins (there really is no relationship between them), so they are explored in the order in which they appear in the form, which is alphabetical. Note, however, that for some of them their usage has changed over time, so the names are not necessarily clear explanations of what they do.

Each of the plug-ins contain comments that explain (or, at least, should explain) the parameters that are passed in and the form of the result. Thus, the explanations here address the general concepts of their usage.

It can be very helpful to think of these plug-ins as event handlers.  Until you are quite familiar with the use of IntellisenseX, their relevance may be hard to see, just as the relevance of many event handlers for a FoxPro object may be hard to see at first.  Eventually, though, you may come across a situation where IntellisenseX does not provide a dropdown, but you can imagine it would be possible to do so. At that time, search through the list of plug-ins to see which might apply, open it up and dig through the sample code.

You need not be concerned about when a plug-in is called, just as you are not concerned about when an event handler fires. The plug-in will be called when it is appropriate.

#### “Data Objects” Plug-In

This plug-in allows you to identify an object (or table) referenced in some form of nested usage, such as:

*   This.oCustomers
*   ThisForm.oBusObj
*   ThisForm.oBusObj.oData
*   Thisform.oJob.oCustomers.oData
*   loJob.oData

The plug-in is called when IntellisenseX has been able to resolve part of the name (“Thisform” or “Thisform.oBusObj” e.g.,) into a real object but not the member name (“oData” or “oParts”, e.g.) and is called with the object (in a unique structure – see the comments) and the member name as parameters.  The Plug-In can return the appropriate object or table reference, if appropriate.

Expanding on the previous bullet points:

*   This.oCustomers – if a consistent naming conventions is used for objects (such as “oCustomers” here), the plug-in could take the characters after the “o” and see if there is a business object to handle that name, returning that object.
*   ThisForm.oBusObj – similar to the previous item, but the plug-in could look for an property (“cAlias”, e.g.,) that identifies the table for the business object being referenced.
*   ThisForm.oBusObj.oData – similar to the previous item, but instead of returning the business object being referenced, returns the alias referred to in the property (“cAlias”), causing the drop down to show the fields from that table.
*   Thisform.oJob.oCustomers.oData – the plug-in may be called multiple times to obtain a single dropdown list; in this case, first to resolve “Thisform.oJob”, then “Thisform.oJob.oCustomers”, and finally “Thisform.oJob.oCustomers.oData”. This is transparent to you, however.
*   loJob.oData – can provide the dropdown list of fields from the loJob table – if loJob can already have been resolved into an object. That can be done by the next Plug-In, “IntellisenseX”.

#### “IntellisenseX” Plug-In

This plug-in allows you to identify an object (or table) based on the entire text that precedes the dot that you entered. That entire text is passed in as a parameter. 

This plug-in is closely related to the “Data Objects” plug-in, and is called in all cases where the “Data Objects” plug-in was unable to return a usable result. The difference between the two is the parameters that are passed in.

But it can also handle getting “loJob” as a parameter (in this case, the “Data Objects” plug-in is not called).  If “loJob” can be resolved into an object by this plug-in, there will be a dropdown list for loJob.

This plug-in is also called by PEM Editor when you are setting the values of properties, allowing you to get dropdown lists for tables of data objects when setting a ControlSource.

#### “New Object” Plug-In

Use this plug-in when you use a UDF to create objects, instead of NEWOBJECT() or CREATEOBJECT().  In the example below, my personal use of the plug-in allows Intellisense to recognize my use of a UDF named NewSessionObject (which happens to use the same parameters as NEWOBJECT, but this is not necessary).

![](Images/Tweet21c.png)

#### “Open Table” Plug-In

When IntellisenseX encounters a single (non-nested) name before the dot, it checks whether the name corresponds to an existing alias, or (optionally) the name a of table in your SQL Server database, or the name of a file in the path, in the Data Environment or an open DBC, or (optionally) in the MRU list. All of this is handled by the default version of this plug-in.

The plug-in is called with the potential table name as its parameter. In my universe, all table names and the folders they are found in are themselves stored in a table, where the alias is used as a key to the table. These tables are only opened by a single UDF which takes the alias as a parameter. My personal version of this plug-in calls this UDF to open the table.

There are examples of other uses in the comments in the code.

#### “Spell Field Names” Plug-In

This plug-in has been essentially superseded by the [Custom Keyword List](Tweet_19.md), but can be used in cases where the Custom Keyword List is not used, is insufficient, or there are other rules for field names (such as project or customer specific rules).

******Other IntellisenseX tools******

There are a number of other IntellisenseX-related tools that show up in the Tool Launcher when you filter by “IntellisenseX”.  These tools use the same framework developed to give the dropdown lists when you press a dot, but provide other features that are activated differently.  They will be described in the next TWEeT.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
