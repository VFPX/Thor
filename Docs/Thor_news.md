
# Thor News

**Go To Definition Enhancements** 
---

### #48, 2023-02-05

This new VFPX project is a completely refactored version of the original Go To Definition (GTD). The code was created before we had Thor, so it was embedded into the older PEMEditor App. This, along with the fact that GTD evolved incrementally over a long period of time, made it a prime candidate for refactoring. GTD is now a standalone tool, simplifying the tasks of updating or documenting. All of the original features of GTD should work as they have always had, with the following enhancements:

* [IntelliSenseX (ISX)](https://github.com/VFPX/IntelliSenseX) provides dropdown lists for PEMs (properties, events, and methods) for objects referenced in code.  GTD now uses ISX in two new ways:
    * If ISX can provide a dropdown list of PEMs for an object, then using GTD will open the definition of that object.  
    * In addition, GTD will open an object's definition and associated method code if you use GTD on a method from the object.  
        
> This is especially useful for objects described in the "Hidden gems" section in [Thor News Item 47](https://github.com/VFPX/Thor/blob/master/Docs/NewsItems/Item_47.md).


* GTD now creates bookmarks each time it is used, one placed where GTD was invoked and one at its destination (if in a code window).  Two Thor tools work with these bookmarks
    * **Cycle Bookmarks** takes you through all your current bookmarks.
    * **Add/Remove BookMark** will add a bookmark at the current location if there isn't one there or remove the current bookmark if there is.
    
> Bookmarks are defined by the window (not its contents) and the cursor position in that window.  They are automatically removed when the window is closed.  Also, they may be out of sync if the code in the window above the bookmark cursor position has been modified.

* If you use GTD on the name of an object that actually exists (other than in the SCX or VCX you are editing), GTD will open **Object Explorer**. An example (although not a very useful one), would be to use GTD on _Screen.
* GTD would seemingly have nothing to do if the active window is not a code window (the  form or class you are edititing, the Property Window, Class Browser, PEM Editor, etc) or if the cursor is in white space in a code window.  In these cases, the "Add new PEM" window is opened.

---

See also
* [Thor Forum](http://groups.google.com/group/FoxProThor)

* [Thor Videos](Thor_videos.md)

---

Headlines History
---

**[2023-02-04 : Go To Definition Enhancements ](NewsItems/Item_48.md)** 

**[2023-01-27 : IntelliSenseX Enhancements ](NewsItems/Item_47.md)** 

**[2023-01-20 : Two New Thor Tools: "Execute Selected Text" and "Highlight Current Statement" ](NewsItems/Item_46.md)** 

**[2023-01-13 : Class Browser Enhancements](NewsItems/Item_45.md)** 

**[2023-01-06 : FoxTabs Enhancements](NewsItems/Item_44.md)** 

**[2022-12-26 : Object Explorer Enhancements](NewsItems/Item_43.md)** 

**[2015-11-30 : New Thor Tools and SuperBrowse Enhancements](NewsItems/Item_42.md)**

**[2015-01-12 : New VFPX Projects - ThemedTitleBar and VFP 9 SP2 Hotfix 3 Download](NewsItems/Item_41.md)**

**[2014-01-04 : Go To Definition](NewsItems/Tweet_27.md)**

**[2014-12-22 : Three New Thor Tools](NewsItems/Tweet_26.md)**

**[2014-12-17 : New VFPX Projects - VFP Runtime Installers and StripeX](NewsItems/Item_38.md)**

**[2014-11-30 : Five New Thor Tools for FoxBin2PRG](NewsItems/Tweet_25.md)**

**[2014-11-25 : Nine New Thor Tools](NewsItems/Tweet_24.md)**

**[2014-11-17 : Buffer Overrun Detected!](NewsItems/Tweet_23.md)**

**[2014-06-11 : Related IntellisenseX Tools](NewsItems/Tweet_22.md)**

**[2014-06-04 : Advanced Features: Plug-Ins for IntellisenseX](NewsItems/Tweet_21.md)**

**[2014-05-29 : Quick Start Guide to IntellisenseX](NewsItems/Tweet_20.md)**

**[2014-05-21 : Deficiencies in IntellisenseX (and how to avoid them) … The Custom Keyword List](NewsItems/Tweet_19.md)**

**[2014-05-10 : IntellisenseX for Nested Objects](NewsItems/Tweet_18.md)**

**[2014-04-29 : Using Local Aliases in IntellisenseX](NewsItems/Tweet_17.md)**

**[2014-03-03 : Custom Keyword List for Field Names](NewsItems/Tweet_16.md)**

**[2014-02-24 : IntellisenseX and the Alias Dictionary](NewsItems/Tweet_15.md)**

**[2014-02-17 : IntellisenseX for Objects](NewsItems/Tweet_14.md)**

**[2014-02-10 : New (hidden) IntellisenseX Feature](NewsItems/Tweet_13.md)**

**[2014-02-03 : IntellisenseX by Dot or by Hot Key?](NewsItems/Tweet_12.md)**

**[2014-01-27 : IntellisenseX: Aliases for VFP Tables](NewsItems/Tweet_11.md)**

**[2014-01-20 : IntellisenseX: Field Names from SQL Server Tables](NewsItems/Tweet_10.md)**

**[2014-01-13 : Extract to Variable and Extract to Constant](NewsItems/Tweet_09.md)**

**[2014-01-05 : Creating Properties and Methods (#3)](NewsItems/Tweet_08.md)**

**[2013-12-18 : Creating Properties and Methods (#2)](NewsItems/Tweet_07.md)**

**[2013-08-26 :  Thor Version 1.40 released: Thor ToolBar](NewsItems/Item_18.md)**

**[2013-06-23 :  New VFPX Project: Finder](NewsItems/Item_17.md)**

**[2012-01-16 :  Thor videos available from Thor menu](NewsItems/Item_14.md)**

**[2012-01-05 :  Thor's Tool Launcher: The one tool you must use](NewsItems/Item_13.md)**

**[2012-11-16 :  Thor menus provide access to Discussion Forums and Change Logs](NewsItems/Item_12.md)**

**[2012-10-14 :  New VFPX Project: FoxcodePlus](NewsItems/Item_10.md)**

**[2012-10-06 :  Easy access to all VFPX home pages](NewsItems/Item_9.md)**

**[2012-09-30 :  New VFPX project: IntellisenseX](NewsItems/Item_8.md)**

**[2012-09-19 :  All VFPX projects can be downloaded from Thor](NewsItems/Item_7.md)**

**[2012-09-16 :  Use the Thor discussion group](NewsItems/Item_6.md)**

**[2012-09-10 :  IntellisenseX released](NewsItems/Item_5.md)**

**[2012-09-09 :  Data Explorer is now a Thor tool](NewsItems/Item_4.md)**

**[2012-09-04 :  New VFPX Projects: Dynamic Forms & Data Explorer](NewsItems/Item_3.md)**

**[2012-08-25 : Introducing Thor News](NewsItems/Item_1.md)**

---


Last changed: _2023-01-13_ ![Picture](Images/vfpxpoweredby_alternative.gif)

