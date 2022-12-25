#  Creates two files in ThorUpdater folder:
#     Thor.Zip -- installed version of Thor
#     Updates.Zip -- the collection of updaters for all projects supported by CFU

$SourceFolder = $pwd

#####################################
# First, the installed files
cd '..\Installed Files'

# Get the name of the zip file.
$zipFileName = "..\ThorUpdater\Thor.zip"

 # Delete the zip file if it exists.
    $exists = Test-Path ($zipFileName)
    if ($exists)
    {
        del ($zipFileName)
    }
    
Compress-Archive -Path * -DestinationPath $zipFileName
cd $SourceFolder

#####################################
# Then the updaters
cd '..\Updaters'

# Get the name of the zip file.
$zipFileName = "..\ThorUpdater\Updates.zip"

 # Delete the zip file if it exists.
    $exists = Test-Path ($zipFileName)
    if ($exists)
    {
        del ($zipFileName)
    }
    
Compress-Archive -Path * -DestinationPath $zipFileName
cd $SourceFolder

Write-Host "Update creation successful"
