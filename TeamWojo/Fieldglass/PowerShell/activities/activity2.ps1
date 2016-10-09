# https://data.illinois.gov/api/views/5gzq-577f/rows.csv?accessType=DOWNLOAD

# obtain current working directory in powershell
$workingPath = Read-Host "C:\Users\I842756\Desktop\Activities"

# current source data to retrieve data
$mySourceDataPath = Read-Host "https://data.illinois.gov/api/views/5gzq-577f/rows.csv?accessType=DOWNLOAD"

# Destination Filename
$myDestinationFileName = Read-Host "Destination Filename"
#Destination path for data on local machine
$myDestinationDataPath = ($workingPath + "\" + $myDestinationFileName)

# Initialize counter
$i = 0

# Countdown before we start doing stuff
for($j = 10; $j -ge 0; $j--)
{
    Write-Host $j.ToString()
    Start-Sleep -m 1000
}

# Create working directory
new-item -path $workingPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# Retrieve data
Get-Public-Dataset -SourceDataPath $mySourceDataPath -DestinationDataPath $myDestinationDataPath

# Import and sort data
Import-Public-Dataset -SourceDataPath $myDestinationDataPath

# Function to retrieve a public dataset and store in a defined path
function Get-Public-Dataset($SourceDataPath, $DestinationDataPath)
{
    # Retrieve the data file from the internet
    $GetSourceDataPath = Invoke-WebRequest $SourceDataPath -OutFile $DestinationDataPath

    do {
            $ValidSourceDataPath = Test-Path -Path $DestinationDataPath
        } Until ( $ValidSourceDataPath -eq $true )
}

# Function to import the public data set
function Import-Public-DataSet($SourceDataPath)
{
    $myDataSetObject = Import-Csv -Path $SourceDataPath -Header 'YEAR','NUMBER OF FIREARM TRANSFER INQUIRY REQUESTS' -Delimiter "," | Sort-Object -Descending { $_.'NUMBER OF FIREARM TRANSFER INQUIRY REQUESTS' } | `

    ForEach-Object {
                    if($_.Year -ne "YEAR")
                    {
                        Write-Host ($i.ToString() + ". " + "In "  + $_.Year + " there were " + $_.'NUMBER OF FIREARM TRANSFER INQUIRY REQUESTS' + " Illinois FOID application requests.")
                     }
                     else
                     {
                        Write-Host ("ILLINOIS FOID APPLICATION SUMMARY")
                      }

                      $i = $i + 1
                    }

    return $myDataSetObject
}