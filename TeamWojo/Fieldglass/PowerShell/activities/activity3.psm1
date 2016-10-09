<#  Cmdlets Included
        
        Invoke-WebRequest
        Import-Csv
        Write-Host
        Read-Host
        Sort-Object
        New-Item
        Out-Null
        Start-Sleep
    
    Loops Included
       Do {} Until ()
       ForEach-Object {}
       For
       
     
    String Concatenation
    

    Source Data Note: https://data.illinois.gov/api/views/5gzq-577f/rows.csv?accessType=DOWNLOAD

#>


<#  FUNCTIONS  #>


#Function to retrieve a public dataset and store in defined path

function Get-PublicDataset ()
{

    param( 
    
           [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True)]
           [string]$SourceDataPath,
           [Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$True)]
           [string]$DestinationDataPath

           )


    #Retrieve the Data File from the Internet
    $GetSourceDataPath = Invoke-WebRequest $SourceDataPath -OutFile $DestinationDataPath
    
    #loop until 
    do {

        $ValidSourceDataPath = Test-Path -Path $DestinationDataPath


        } Until ( $ValidSourceDataPath -eq $true )

}
 


#Function to import the public data set  
function Import-PublicDataset () 
{
    param(
        
        [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True)]
        [string]$SourceDataPath
        
         )

     $myDataSetObject = Import-Csv -Path $SourceDataPath 
    
     return ,$myDataSetObject

} 

Export-ModuleMember -Function 'Get-PublicDataset'
Export-ModuleMember -Function 'Import-PublicDataset'
