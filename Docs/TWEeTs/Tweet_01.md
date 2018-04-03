Thor TWEeT #1:
===

### [PEM Editor](https://github.com/VFPX/PEMEditor), [GoFish](https://github.com/mattslay/GoFish), and Replace code window context menu items

While at SW Fox, I realized that many of the tools from Thor aren't being used because there are simply so many of them. It seems that there might be wider usage if they were properly introduced, at a more relaxed pace.

Thus, I will be describing one tool a week in something I will refer to as TWeeTs (**T**his **W**eek's **E**xc**e**ptional **T**ools).

I will take the easy way out this week, noting two tools that (ahem) you should not do without:  [PEM Editor](https://github.com/VFPX/PEMEditor) and [GoFish](https://github.com/mattslay/GoFish).

I think that not much needs to be said about these two since their acceptance has been almost universal. (Except this: if you're not using them, you are really missing out)

There is a related Thor tool you should be aware of, a tool with a rather cumbersome name: **Replace code window context menu items**.

This tool updates the _FoxRef system variable so that two options in the context menu in a code window use Thor tools instead:

      Option "View Definition"       uses **Go To Definition** (I will describe this tool in another TWeeT)

      Option "Look up Reference" uses **GoFish**

This will not affect the use of Code References from the VFP Tools Menu. (To be honest, even though I am the Project Manager in VFPX for Code References, I have not used Code References in years, as I use [GoFish](https://github.com/mattslay/GoFish) instead.)

**Replace code window context menu items** only needs to be executed once in each IDE session. The recommended way to do this is to check "Run at StartUp" on the Tool Definitions page.

See also [History of all Thor TWEeTs](../TWEeTs.md) and [the Thor Forum](https://groups.google.com/forum/?fromgroups#!forum/FoxProThor).