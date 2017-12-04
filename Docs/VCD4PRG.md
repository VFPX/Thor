#### Version 0.9 – Sept. 3, 201

### Objective

To create a tool which provides the ability to modify PRG-based custom classes using the Visual Class Designer (limited to classes that do not contain child objects).

### Benefits

All the benefits of the Visual Class Designer (inheritance, Intellisense, having multiple code windows open simultaneously, etc) and the IDE Tools of Thor (GoToDefinition, ExtractToMethod, etc.)

### Usage

VCD4PRG is accessible from the Thor menu, as seen below.  For best test results, assign and use a hot key.

![](Images\VCD4PRG_image_2.png)

### **Getting started – an example**

There are a number of different ways of using VCD4PRG to begin working on a PRG-based class.  Here are the steps for the simplest example:

1.  Use ‘Modify Command’ on the PRG and place the cursor somewhere within the class definition
2.  Use the tool (as described above).  This will convert the class into a temporary VCX-based class.
3.  Make any modifications to the class as desired (adding properties, methods, etc …)
4.  With the current window being either the temporary VCX or any method window, use the tool again to write the class definition back into the code window for the PRG.

### Irreconcilable Differences

There are clearly differences between PRG-based classes and VCX-based classes, so when converting from PRG to VCX there must be accommodations for the structures which can be used in PRG-based classes but which have no direct counterpart in VCX-based classes.  Since the VCX must contain an entire re-definition of the PRG-based class, this requires some gymnastics that you must be very aware of:

*   There is no standard for the definition of *descriptions of properties* in PRG-based classes. A fairly common usage, however, is to describe a property in the PRG either on the line before the property is defined or in comments on the same line (such as is described by Rick Strahl in West-Wind Help Builder). This is the definition that is used here.  (To allow for longer descriptions, the “preceding line” may actually be multiple lines with the continuation character).  Property descriptions created in the VCX will be exported in this format.
*   There is also no standard for the definition of *descriptions of methods* in PRG-based classes. A fairly common usage, however, is to describe a method in the PRG in the lines immediately preceding the PROCEDURE line for the method (again, as is described by Rick Strahl in West-Wind Help Builder). This is the definition that is used here, noting that this refers to a number of consecutive lines beginning with a comment and without any intervening blank lines. Since descriptions for methods are frequently much longer than the limit of 254 characters in VCXs, these comment lines are transferred into the beginning of the method itself.  Thus, when exported back to the PRG, they will appear *within the method, not outside it*.
*   PRG-based classes allow for multiple #Include statements, as well as #Define statements and comments anywhere in the class definition and there is no equivalent structure in VCXs.  All of these lines (with the exception of the comment lines noted above) are captured and restored into the PRG immediately after the DEFINE CLASS statement.  Note that this include comments between PROCEDURES and also after the last ENDPROC
*   PRG-based classes also provide for the assign of values into arrays, something that have no equivalent in VCXs.  These assignments are placed into the beginning of the INIT of the class.
*   PRG-based classes allow for the listing of LParameters on the same line as the procedure definition:  PROCEDURE SomeProcedure(Parameter-list). These parameters are moved into a LParameters list in the method.

### Handling of non-visual classes

There are four classes which cannot be represented in VCXs (Session, Column, Header, and Exception).  These classes can still be edited using VCD4PRG, as the temporary VCX that they are exported into is based on the custom class.  When posted back to the PRG, they are re-created using the base class on which they were originally defined.

### Alternate methods for starting VCD4PRG

*   #### From a PRG opened in a code window:

    *   If the cursor is within a procedure within a class definition, that class will be used and that procedure will be opened
    *   Else, if the cursor is within a class definition, but not within a procedure, the class will be opened.
    *   Else, a pop-up form will allow selection of a class from the code window.
*   #### If the current window is any other window that a PRG, Class Designer, or method window:

    *   GetFile(‘PRG’) is used to select a file containing PRG-base class(es), and then a pop-up form will allow selection of a class from the PRG file.  Note that the PRG file itself is _not_ opened.
*   #### Opening programmatically:

    *   The following line of code can be used to open a class programmatically, rather than by hot key.  I

```foxpro
Result = ExecScript (_screen.cThorDispatcher, 'THOR_TOOL_REPOSITORY_VCD4PRG', lcSomePRGFileName)
```


*   Note that if the named PRG has any classes, you will be prompted for the class to open; if none, the file will be opened with Modify Command. Thus, this line can be inserted into the QueryModifyFile event of a Project Hook when opening a PRG, and the only change in behavior will occur if there are classes in the file.

### Revision History

Version 0.9 – Sept. 3, 2011

*   Text between #IF / #ENDIF statements left untouched (treated like comments)
*   Backup file *.BAK created when PRG file is updated.
*   Descriptions in VCX for methods are (and should be) ignored.
*   Recognizes parent classes from VCXs
*   Generates appropriate error message if parent class not found

Version 0.04 – Sept. 1, 2011

*   Resolution for problem of finding parent class from the DEFINE CLASS statement
*   Handling for comments, #Include statements, #Define statements that are not with Procedure blocks
*   Implementation of a structure for property descriptions, based on Rick Strahl’s WestWind

Version 0.02 – Aug 27, 2011

*   When saving, all VCX/SCX code windows are closed (saved) first, to make sure that no work is lost. Unfortunately, it is not possible to distinguish between VCX and SCX code windows, nor which VCX or SCX they belong to, so in the case where there are multiple VCXs or SCXs open, ALL their code windows are closed.
*   Classes which cannot be defined in VCXs (Session, Column, and Header') can be edited; they are made to appear as ‘Custom’ classes, meaning that there may be some native PEMs which are handled wrong (but this should be minor). 
*   When writing back to a file rather than a code window, MessageBox is used to notify that posting was complete.  An appropriate message will be displayed should posting should fail for any reason (such as if the file has subsequently been opened for editing by Modify Command)
