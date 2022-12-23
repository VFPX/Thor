Thor TWEeT #16: Custom Keyword List for Field Names
===

The new feature of Custom Keyword List for field names has been shown in a number of images in earlier TWEeTs (including the one below, from [IntellisenseX: Aliases for VFP Tables](Tweet_11.md)), without ever being described.

![](Images/Tweet16a.png)

Did you notice that some of the field names use upper case(“Field_Type”, e.g.,) in the middle? The Custom Keyword List allows you to define the case that is to be used for field names.

#### How is this done?

Thor maintains a table of **global** definitions of field names (and for other names, but that is addressed in another TWEeT, [Custom Keyword List - all other names](Tweet_19.md)).  The table has a single field, containing the field names as you want them to be represented.  You can open the table for editing by using Thor tool **Browse Custom Keyword List**, although that’s not a very convenient way to go about building the table.

Instead, there are a number of Thor tools you can use:

*   **Add highlighted word** – adds the currently highlighted word to the KCL.  If the word is already in the list, the highlighted word replaces it.
*   **Add field names from current table** – opens separate forms for words that are new to the list or might replace existing words on the list. You can edit the values in the “New Value” column (but you can’t change the spelling, only which letters are upper case).

![](Images/Tweet16b.png)

*   [**SuperBrowse**](../Thor_superbrowse.md) – if you mark the checkbox under the list of field names, that list becomes editable, allowing you to change which letters are to be upper case. Simply click on any field name and edit it so that it appears as you would like it to.  Any field name that you change is posted immediately to the Custom Keyword List and will be used any time this field name is referenced for *any* table, not just the current one. (No, you *can't* modify the structure of the file this way -- all you can change is which characters are upper case.)

![](Images/Tweet16c.png)

*   **Add all words from folder or project** – This is the big papa of them all, as it adds all names (not only field names) from all your code to the KCL. Once processing is complete (which may take a few minutes), it brings up the same two forms as shown above under **Add field names from current table.** (Just with a lot more entries).  This is described in more detail in [Custom Keyword List - all other names](Tweet_19.md).

#### Where are these field names in the Custom Keyword List used?

These field names from the Custom Keyword List are used every place in IntellisenseX where tables are referenced (and for both VFP Tables and SQL Server Tables) and as show in SuperBrowse, above.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
