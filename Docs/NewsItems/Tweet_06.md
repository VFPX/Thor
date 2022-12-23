Thor TWEeT #6: Creating Properties and Methods (Part 1)
===

Thor provides quite a range of tools to create new properties and methods. 

There are a couple of common tools that use familiar techniques for creating new properties and methods: 

*   **[PEM Editor](https://github.com/VFPX/PEMEditor)** (about which no more will be said)
*   **Add Property/Method**, the diminutive offspring of **[PEM Editor](https://github.com/VFPX/PEMEditor)**, which uses this simple form:

![](Images/Tweet6a.png)

Both of these tools offer features not available from the standard New Property and New Method:

*   The form is modeless and you can easily switch between adding properties and methods.
*   MemberData is automatically updated if the name contains any uppercase characters.
*   If you are creating a new property:
    *   There is an option to set the initial value of the property based on the first character of the property name (‘c’ = Character, ‘n’ = Numeric, etc). Default = ON
    *   You can create a [Plug-In](../Thor_add_plugins.md) to use some other method for assigning the initial values (such as using the second character)
*   If you are creating a new method:
    *   You can open it immediately for editing.
    *   You can create a [Plug-In](../Thor_add_plugins.md) that will populate the header of the newly created method.

When you use either of these tools, you are following the long-established two-step pattern where the process of creating the new property/method is distinct from using a reference to it.

In next week's TWEeT on this topic, I will demonstrate tools that establish a new pattern: you can create a property or method as you refer to it. Using these tools tends to provide less interruption to your programming flow, as you can create new properties and methods "on the fly".

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
