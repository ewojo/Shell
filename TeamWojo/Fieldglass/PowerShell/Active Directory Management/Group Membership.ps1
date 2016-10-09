# This script is to get a users group membership and export to csv
Import-Module ActiveDirectory
$Username = Read-Host 'UserName'
Get-ADPrincipalGroupMembership -Identity $Username -OutVariable Name | Select-Object Name | Sort-Object Name  | Export-Csv c:\scripts\test.txt