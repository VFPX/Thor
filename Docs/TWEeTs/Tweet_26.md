Thor TWEeT #26: Three New Thor Tools
===

Three new tools have been added recently to the Thor Repository.

*   _[Split a Procedure File](#T1)_
*   _[Find Buffer Overrun Threats](#T2)_
*   _[Compress Parameters List](#T3)_

### <a name="T1"></a>Split a Procedure File

The tool _Split a Procedure File_ splits out all procedures and functions from a PRG file into separate PRG files. 

It first prompts for the name of the procedure file and then for the folder in which the new PRGs are to be created.

Note that this creates new PRGs for procedures and functions, but does nothing for classes.

Thanks to Tamar Granor for this contribution.

### <a name="T2"></a>Find Buffer Overrun Threats

As described in [TWEeT #23: Buffer Overruns](Tweet_23.md), you may encounter buffer overrun errors when using PEM Editor or IntellisensesX on some forms and classes.  This unusual error, which blows away your session like a C5 error, is caused by long Parameter or LParameter statements.

The tool _Find Buffer Overrun Threats_ searches a project or folder with sub-folders for statements which might cause buffer overrun errors. Note the use of the word “might”; it is difficult to pin down the exact case where these errors occur, as the rules are different in PRGs than in VCXs and are affected by internal comments.

The result from running this tool is a cursor, shown using _Super Browse_.

![](Images/Tweet26a.png)

To test whether any of the threats identified in the cursor will actually generate a buffer overrun, run the following:

```foxpro
oObject = Newobject(‘yourclass’, ‘yourclasslib’, 0)
 
?Amembers(laArray, oObject, 3)
```

### <a name="T3"></a>Compress Parameters List

Use tool _Compress Parameters List_ to fix any long Parameters lists that are causing buffer overrun errors.

Navigate to the problem code, highlight the entire parameters statement, and run this tool.  It will remove all un-necessary characters from the statement (including spaces, tabs, CRs, LFs, semi-colons, and end-of-line comments.)

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#%21forum/FoxProThor).