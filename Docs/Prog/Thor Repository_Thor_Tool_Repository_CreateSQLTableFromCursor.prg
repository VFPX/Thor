Lparameters lxParam1
local laFields[1], ;
     lnFields, ;
     lcSQL, ;
     lnI, ;
     lcType
 
****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.
 
If Pcount() = 1                              ;
           And 'O' = Vartype (lxParam1)  ;
           And 'thorinfo' = Lower (lxParam1.Class)
 
     With lxParam1
    
           * Required
           .Prompt        = 'Create SQL from cursor' && used when tool appears in a menu
           .Description   = 'Puts a CREATE CURSOR SQL statement on the clipboard from an open cursor' && may be lengthy, including CRs, etc
          
           * For public tools, such as PEM Editor, etc.
           .Source        = 'Thor Repository' && e.g., 'PEM Editor'
	 	   .Category      = 'Tables'
           .Author        = 'Doug Hennig'
     Endwith
 
     Return lxParam1
Endif
 
****************************************************************
****************************************************************
* Normal processing for this tool begins here.   
 
#define ccCR chr(13) + chr(10) + chr(9)
if empty(alias())
     messagebox('Please open a table or cursor first.', 0 + 16, 'Create Cursor Tool')
     return
endif empty(alias())
lnFields = afields(laFields)
lcSQL    = ''
for lnI = 1 to lnFields
     lcType = laFields[lnI, 2]
     lcSQL  = lcSQL + ;
           iif(empty(lcSQL), 'create cursor TEMP ;' + ccCR + '(', ', ;' + ccCR) + ;
           laFields[lnI, 1] + ' ' + lcType
     do case
           case lcType $ 'CVQ'
                lcSQL = lcSQL + '(' + transform(laFields[lnI, 3]) + ')'
           case lcType $ 'NF'
                lcSQL = lcSQL + '(' + transform(laFields[lnI, 3]) + ',' + ;
                     transform(laFields[lnI, 4]) + ')'
           case lcType = 'B'
                lcSQL = lcSQL + '(' + transform(laFields[lnI, 4]) + ')'
     endcase
next lnI
_cliptext = lcSQL + ')'
 