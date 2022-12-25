Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"StripeX installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'StripeX'
    .Component            = 'Yes'
    .VersionLocalFilename = 'StripeX VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1.8'
    .VersionDate          = Date(2016,  1, 12)
    .ProjectCreationDate  = Date(2014, 12, 8)


    .SourceFileUrl        = 'https://github.com/VFPX/StripeX/archive/refs/heads/master.zip'
    .Link                 = 'http://github.com/VFPX/StripeX'
    .LinkPrompt           = 'StripeX Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
A wrapper class for working with Stripe.com. Currently supports:

-- Authenticating a stripe.com connection and account
-- Charging a credit card

1.7: Added Plan & Subscription functions
1.6: Added functions for working with Cards. Added utility function ObjectExtract to retrieve values from Stripe objects. 
1.2: Added currency type, fixed some return values 
1.1: Added functions for adding/updating customer records
    EndText
    Return lcNotes
EndProc
