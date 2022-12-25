Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"FoxCharts installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'FoxCharts'
    .Component            = 'Yes'
    .VersionLocalFilename = 'FoxChartsVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'FoxCharts - 1.20 Production - December 19, 2009 - 20091219'
    .SourceFileUrl        = 'https://github.com/VFPX/FoxCharts/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FoxCharts'
    .LinkPrompt           = 'FoxCharts Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
A class based on the ImageCanvas class from GdiPlusX that allows VFP developers to directly draw charts and graphs.

Project Manager is Cesar, who can be reached at: vfpimaging@hotmail.com

Goals of FoxCharts:
    Create good looking and modern charts in pure VFP code
    NO ActiveX components
    Easy to setup
    Easy to customize
    Easy to save to disk or print
    Open Source
    Benefit from all the GdiPlusX drawing capabilities, allowing users to modify the charts the way they like
    Save as EMF, resulting in perfect charts when printed in VFP reports
    Full control of the chart shapes
    Tooltips
    Mouse control
    
Prerequisites:
    Visual FoxPro 9 and the GdiPlusX library from VFPX 

Currently available:
    Single Bars, Multiple Bars, Stacked Bars, Shapes or points, Lines, Area, Pie and Donut charts, 
        in various color variations, using gradients, custom colors, transparent, basic and random colors.
    Titles, subtitles and legends
    Scales, Both Axis
    Drawing texts inside shapes

    EndText
    Return lcNotes
EndProc
