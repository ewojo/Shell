<#
#This is used to connect to the Monsoon dev ops lab

$UserCredential = Get-Credential
Import-Module activedirectory
New-PSDrive -Name FGDEVOPSLAB -PSProvider ActiveDirectory -Root "DC=FGDEVOPSLAB,DC=local" -Server mo-66bba323d.mo.sap.corp:389 -Credential $UserCredential
Set-Location FGDEVOPSLAB:
#>

#Sets number of days before password expiry for accounts to be included in the csv
$ExpiresInDays = 30

#Path for CSV
$CSVPath = "c:\temp\PasswordsExpiring.csv"

#Gets users with an msDS-UserPasswordExpiryTimeComputed property included
$Users = Get-ADUser -Filter {(Enabled -eq $true) -and (pwdlastset -ne 0) -and (PasswordNeverExpires -eq $false)} -Properties msDS-UserPasswordExpiryTimeComputed

#Create an array to store the users with expiring passwords
$UsersExpiringPwds = @()

#Loops through users in the $Users array
foreach ($User in $Users) {
    
    #If the password expiry is less than today's date plus the days specified.
    if ($User."msDS-UserPasswordExpiryTimeComputed" -lt (Get-Date).AddDays($ExpiresInDays).ToFileTimeUtc()) {

        #Add the user object to the array.
        $UsersExpiringPwds = $UsersExpiringPwds + $User

    }
    
}
#Export the array of user objects to csv. Also converts the data to a human readable format.
$UsersExpiringPwds | Select -Property "Name",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}  | export-csv $CSVPath