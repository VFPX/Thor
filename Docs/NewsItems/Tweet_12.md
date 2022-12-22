Thor TWEeT #12: IntellisenseX by Dot or by Hot Key?
===

There are two different ways that you can invoke [IntellisenseX](https://github.com/VFPX/IntelliSenseX):

*   Tool **IntellisenseX by Dot** is a toggle that turns on/turns off the use of IntellisenseX. When turned on, IntellisenseX is invoked every time you press the dot (the period).
*   Tool **IntellisenseX by HotKey** causes IntellisenseX to be invoked only when you press the hot key you have assigned to it. You press the hot key when you want IntellisenseX (and it supplies the dot for you)

Watch this video:  [“IntellisenseX by Dot” vs “IntellisenseX by Hot Key”](http://www.youtube.com/watch?v=71psd6RH2Ls&hd=1&rel=0) (3:29)

**IntellisenseX by Dot** is the “natural” way to invoke IntellisenseX, as it mimics the way native Intellisense works. There are some minor issues with it, however, including the following:

*   The selection box may be slow in coming up, particularly when listing properties and methods for an object. (This may be addressed to some degree with the release of an upcoming suite of tools “Custom Keyword List”.)
*   It may stumble over itself a little when you enter any of .T., .F., or .NULL. This can be avoided by typing slower, but nobody wants to do that.
*   It uses a timer that fires every second, which can cause annoying behavior in the debugger. The timer is absolutely essential since **IntellisenseX by Dot** must be disabled when the focus is not on a code window

All of these issues can be overcome by using **IntellisenseX by HotKey** instead, each time you want to invoke IntellisenseX.  However, besides learning to use a different key than dot to invoke Intellisense, there is another drawback as well – as you will see in upcoming TWEeTs, there are features available from IntellisenseX not provided by native Intellisense. These will come as a pleasant surprise if using **IntellisenseX by Dot** (the selection box will simply appear when you press the dot). The solution is to use **Intellisense by HotKey** when you’d like it if IntellisenseX were available (even if you know native Intellisense will do nothing).

#### Other features from IntellisenseX by Hot Key

There are two features that are only available from **IntellisenseX by HotKey:**

*   If you enter the name of a DBC following by a ‘!’ and then use **IntellisenseX by HotKey**, the selection box lists all tables and views in that DBC.  (If the database is already open, you need not enter the DBC name). This list, curiously, also include files from the Data Environment of a form being edited.
*   If you enter a ‘*’ followed by **IntellisenseX by HotKey**, the selection box lists all tables in the current folder and the path.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).
