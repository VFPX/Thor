#include FOXPRO.H

* Virtual key codes.

#define VK_SHIFT				0x10
#define VK_CONTROL				0x11
#define VK_MENU					0x12

* Modifier key values.

#define cnNO_MODIFIER			0
#define cnSHIFT					1
#define cnCTRL					2
#define cnALT					4

#define     ccCR			    chr(13)
#define     ccLF			    chr(10)
#define     ccCRLF			    chr(13) + chr(10)
#define     ccTAB			    chr(9)

#Define     ccTOOLNAMEPREFIX		'Thor_Tool_'

#define     ccINTERNALEDITPRG		ccTOOLNAMEPREFIX + 'ThorInternalEdit.PRG'
#define     ccINTERNALHELPPRG		ccTOOLNAMEPREFIX + 'ThorInternalHelp.PRG'
#define     ccINTERNALALLTOOLSPRG	ccTOOLNAMEPREFIX + 'ThorInternalAllTools.PRG'
#define     ccINTERNALFRAMEWORK   	ccTOOLNAMEPREFIX + 'ThorInternalFrameWork.PRG'
#define     ccCHECKFORUPDATES   	ccTOOLNAMEPREFIX + 'Thor_CheckForUpdates.PRG'
#define     ccCOMMUNITY   	        ccTOOLNAMEPREFIX + 'Thor_Community.PRG'
#define     ccThorNews   	        ccTOOLNAMEPREFIX + 'ThorInternalThorNews.PRG'
#define     ccThorTWEeTs 	        ccTOOLNAMEPREFIX + 'ThorInternalTWEeTs.PRG'
#define     ccINTERNALRepostitory	ccTOOLNAMEPREFIX + 'ThorInternalRepositoryHomePage.PRG'
#define     ccINTERNALMODIFY   		ccTOOLNAMEPREFIX + 'ThorInternalModifyTool.PRG'
#define     ccINTERNALTOOLLINK   	ccTOOLNAMEPREFIX + 'ThorInternalToolLink.PRG'
#define     ccOPENFOLDERS		   	ccTOOLNAMEPREFIX + 'ThorInternalOpenFolders.PRG'
#define     ccSOURCEFILES		   	ccTOOLNAMEPREFIX + 'ThorInternalSourceFiles.PRG'
#define     ccUSAGESUMMARY		   	ccTOOLNAMEPREFIX + 'ThorInternalUsageSummary.PRG'
#define     ccDEBUGMODE  		   	ccTOOLNAMEPREFIX + 'ThorInternalDebugMode.PRG'
#Define     ccMANAGEPLUGINS  		ccTOOLNAMEPREFIX + 'ThorInternalManagePlugIns.PRG'
#Define     ccTOGGLEDEBUGMODE       'Toggle Debug Mode'

#define     ccMyTools				'My Tools'
#define     ccProcs	   			    'Procs'
#define     ccUpdates	   			'Updates'
#define     ccApps	   			    'Apps'
#define     ccComponents		    'Components'
#define     ccMySettings			ccMyTools + '\Settings'
#define     ccMyTemplates			ccMyTools + '\Templates'
#define     ccMyStartThorUI			ccMyTools + '\StartThorUI'

#Define     ccThorDefaultTemplate   'Thor Default'

#Define     ccTemplatePrefix    'Thor_Tool_Template_'

#Define     ccOnKeyLabelPrefix  'ExecScript(_Screen.cThorDispatcher, "'

#Define     ccOnKeyLabelSuffix  '")'

#Define     ccPEMEditor              'IDE Tools'