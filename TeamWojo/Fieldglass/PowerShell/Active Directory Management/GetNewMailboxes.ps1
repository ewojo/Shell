<#
This script exports a list a mailboxes created after the date specified in the $CreatedAfterDate variable 
to a csv in the path specified in the $CSVPath variable
#>


<#
#Import Exchange Powershell session
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://ex01.fgdevopslab.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
#>


$CreatedAfterDate = [datetime]"08/25/2015"
$CSVPath = "c:\temp\NewMailboxes.csv"

$NewMailboxes = Get-Mailbox | Where {($_.WhenMailboxCreated) –gt $CreatedAfterDate} 
$NewMailboxes | Select Name, PrimarySmtpAddress, SamAccountName, WhenMailboxCreated | Export-csv $CSVPath
