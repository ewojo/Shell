#Foundations of DevOps
#Session 07: Activity 3 - 01

<#  

    Source Data: https://data.illinois.gov/api/views/5gzq-577f/rows.csv?accessType=DOWNLOAD
    Module Path: C:\Users\i842621\Mobile Docs\Shared Documents\Site Reliability Engineering (I842621)\Training and Tools\Foundations of Development Operations\Activities\Activity_03_Module.psm1

#>

#Define Activity 3 Module Path
$myModulePath = 'C:\Users\I842756\Desktop\activities\activity3.psm1'

#Import Module Activity_03_Module
Import-Module -Name $myModulePath -Verbose


#Obtain current working directory in Shell. Be sure to navigate shell to working directory first!
$workingPath = Read-Host "Working Path"

#Current Source Data to retrieve Data
$mySourceDataPath = Read-Host "Public Data Source Url"

#Destination Filename
$myDestinationFilename = Read-Host "Destination Filename"

#Destination Path for Data on local machine
$myDestinationDataPath = ($workingPath + "\" + $myDestinationFileName )

#Initialize counter
$i = 0

#Create Working Directory
new-item -path $workingPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
 
#Retrieve Data
Get-PublicDataset -SourceDataPath $mySourceDataPath -DestinationDataPath $myDestinationDataPath


#Import and Sort Data
$myDataSetObject1 = Import-PublicDataset -SourceDataPath $myDestinationDataPath 

$myDataSetObject1 | Sort-Object -Descending { $_.'NUMBER OF FIREARM TRANSFER INQUIRY REQUESTS' } | `
    
    ForEach-Object { 
        
                        if($_.Year -ne "YEAR")
                        {
                    
                            Write-Host ($i.ToString() + ". " + "In " + $_.Year + " there were " + $_.'NUMBER OF FIREARM TRANSFER INQUIRY REQUESTS' + " Illinois FOID application requests.")
                    
                        }
                        else
                        {

                            Write-Host ("ILLINOIS FOID APPLICATION SUMMARY")
                        
                        }

                        $i++
                    }

#END OF PROGRAM
