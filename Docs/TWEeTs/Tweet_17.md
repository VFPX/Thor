Thor TWEeT #17: Using Local Aliases in <a href="https://github.com/VFPX/IntelliSenseX" target="_blank">IntellisenseX</a>
===

In an earlier TWEeT about [Aliases for VFP Tables](Tweet_15.md), there was a brief and dismissive discussion about Local Aliases.  However, they provide some worthwhile features that are worth discussing.

Local Aliases are like LOCAL statements (`"Local name as class of classlib”`) in two ways:

*   they provide an annotation to your code so that IntellisenseX can provide a drop-down list.
*   they apply only to the current method or procedure.

There are three equivalent ways to define Local Aliases:

*   `**{{** SomeAlias = What-It-Stand-For **}}**`                  … in any comment
*   `***#Alias** SomeAlias = What-It-Stand-For`    … at the beginning of a line
*   `**&&#Alias** SomeAlias = What-It-Stand-For`         … at the end of a line

> _(The bold text above must be entered exactly as is, with no intervening spaces.)_

> **Note: Bowing to popular demand, the first of the statements above (the one with the double curly braces) applies to the *entire* PRG, not merely the Procedure or Function in which it lives.**

`“What-It-Stands-For”` can be any one of a number of things, referring to either tables or objects.

*   A table, cursor, or view name
*   The full or relative path name to a table
*   The name of an SQL table
*   A reference to class from a class library; thus,  `"{{ loObject == {class, classlibrary} }}` “
*   A reference to an object; thus,  “`{{ loObject == Thisform.oParts}}` “
*   An executable expression that returns an object or the name of an table, cursor, or view. This executable must start with an “=”; thus, something like “`{{ loObject = = MyGetObject(‘Parts’)}}` “.  (Note the double ‘=’ signs.)

One handy use of this occurs with variables created using the SCATTER NAME command. 

```foxpro
Select MyTable

Scatter Name loObject && {{ loObject = MyTable }}
```

This provides the dropdown list for the table MyTable when the properties of loObject are referenced.

Note also that `“SomeAlias”` can also refer to compound names, such as `This.oMainObj` or `This.oMainObj.oData`; the substitution rules work the same way.

This TWEeT has addressed Local Aliases; the earlier TWEeT on [the Alias Dictionary](Tweet_15.md) addressed global aliases; and an upcoming TWEet will address Aliases that apply to an entire form or class (both VCX and PRG-based).

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).