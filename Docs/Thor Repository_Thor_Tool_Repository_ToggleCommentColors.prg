Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local oReg As ( Home(2) + 'classes\registry.prg' )
Local lcCurrentColor, lcNewColor
If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'Toggle comment colors'
		.Summary	 = 'Toggle color for comments in edit windows'
		.Description = 'Toggle color for comments in edit windows'

		* For public tools, such as PEM Editor, etc.
		.Source	     = 'Thor Repository' 
  	    .Category    = 'Misc.'
		.Author      = 'Matt Slay'
		.Link	     = 'http://mattslay.com/the-color-of-your-comments/'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.    

* Modified version obtained from link noted above (so that changes to colors are clearer
* Could also be modified to reference any of the colors in editor windows
*
* EditorCommentColor   
* EditorKeywordColor   
* EditorConstantColor  
* EditorNormalColor    
* EditorOperatorColor  
* EditorStringColor    

*– Set the following two constants to match your personal color
*– preference.
*– Current "dim" color is Gray with automatic (white) background.
#Define ccDIM_FOREGROUND 192,192,192
#Define ccDIM_BACKGROUND 255,255,255
#Define COMMENT_COLOR_DIM [RGB(ccDIM_FOREGROUND,ccDIM_BACKGROUND), NoAuto, NoAuto]

*– Current "bright" color is Green with Gray background.
#Define ccBRIGHT_FOREGROUND 0,0,0
#Define ccBRIGHT_BACKGROUND 192,192,192
#Define COMMENT_COLOR_BRIGHT [RGB(ccBRIGHT_FOREGROUND,ccBRIGHT_BACKGROUND), NoAuto, NoAuto]

oReg = Newobject ( 'FoxReg', Home(2) + 'classes\registry.prg' )

If Not oReg.GetFoxOption ( 'EditorCommentColor', @m.lcCurrentColor ) = 0
	Messagebox ( 'Unable to retrieve current Editor Comment Color.', 16, Program() )
	Return .F.
Endif

*– Check which comment color scheme is being used. If the "dim"
*– colors are being used, toggle to "bright" colors, and vice versa.
lcCurrentColor = Upper ( Chrtran ( m.lcCurrentColor, Space(1), Space(0) ) )
If m.lcCurrentColor == Upper ( Chrtran ( COMMENT_COLOR_DIM, Space(1), Space(0) ) )
	lcNewColor = COMMENT_COLOR_BRIGHT
Else
	lcNewColor = COMMENT_COLOR_DIM
Endif

*– Set and apply the new comment color.
oReg.SetFoxOption ( 'EditorCommentColor', m.lcNewColor )
Sys(3056, 1)
