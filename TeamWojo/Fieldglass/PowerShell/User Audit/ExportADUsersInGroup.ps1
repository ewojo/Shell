#Export Users in Group to CSV
Import-Module ActiveDirectory

#Let User Set Location
Write-Host "Please enter the location to export CSV File & CSV FileName (i.e. C:Temp\group.csv)"
$CSVLocation = Read-Host

#Group to Export
Write-Host "Please Enter Group to Export"
$ADGroup = Read-Host

$Group = Get-ADGroupMember -identity “$ADGroup” -Recursive
$Group | get-aduser -Properties |select name,samaccountname,mail |export-csv -path $CSVLocation
