Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"FoxBarCodeQR installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'FoxBarCodeQR'
    .Component            = 'Yes'
    .VersionLocalFilename = 'FoxBarQRCodeVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'FoxBarCodeQR - 1.11 - August 24, 2013 - 20130824'
    .SourceFileUrl        = 'https://github.com/VFPX/FoxBarcodeQR/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FoxBarCodeQR'
    .LinkPrompt           = 'FoxBarCode Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
FoxBarcode is a 100% Visual FoxPro class that provides a tool for generating images with different 
bar code symbologies to be used in VFP forms and reports, or exported to other applications.

Project Manager: VFPEncoding [Guillermo Carrero (Spain) and Luis Maria Guayan (Argentina)]
Features

FoxBarcode supports the following barcode symbologies: 
    Code 128, Code 39, Code 39 Extended (Full ASCII), Code 93, Code 93 Extended (Full ASCII), 
    Standard 2 of 5, Interleaved 2 of 5, EAN-8, EAN-13, UPC-A, 
    UPC-E (EAN and UPC with 2/5 digits supplements), ITF-14, GS1/UCC/EAN-128, Codabar, Code 11, 
    MSI / Plessey, PostNet, MS4SCC, KIX-Code, Telepen, One Track Pharmacode and Two Track Pharmacode.

FoxBarcode supports the following image types: JPG, BMP, GIF, PNG and TIFF

FoxBarcode generates the images with the class gpImage2 (http://sites.google.com/site/gpimage2) 
    of Alexander Golovlev (Russia) and Cesar Ch. (Brazil), based on GDI + and requires gdiplus.dll.

FoxBarcode is compatible with all versions of Visual FoxPro from version 6.0
    EndText
    Return lcNotes
EndProc
