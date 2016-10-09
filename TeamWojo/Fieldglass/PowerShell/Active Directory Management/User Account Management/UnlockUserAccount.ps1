<# This script gives a list of accounts that are currently locked out and lets the user choose an account to unlock #>

<#
#This is used to connect to the Monsoon dev ops lab
$UserCredential = Get-Credential
Import-Module activedirectory
New-PSDrive -Name FGDEVOPSLAB -PSProvider ActiveDirectory -Root "DC=FGDEVOPSLAB,DC=local" -Server mo-66bba323d.mo.sap.corp:389 -Credential $UserCredential
Set-Location FGDEVOPSLAB:
#>

$LockedAccounts = Search-ADAccount -LockedOut

write-host ""

#If locked accounts are found
if ($LockedAccounts) {

    $Count = 0

    #Loop through all users with locked accounts
    foreach ($User in $LockedAccounts) {
        
        write-host $Count". " $User.Name " ("$User.SamAccountName")" -separator ""
        $Count = $Count + 1
    }

    write-host ""
    $Selected = read-host "Type the number for the account you would like to unlock"

    #Search-ADAccount returns an array of ADUser objects if there is more than one user
    if ($count -gt 1) {
        $User = Get-ADUser $LockedAccounts[$Selected] -properties LockedOut
    }
    else {
        $User = Get-ADUser $LockedAccounts -properties LockedOut
    }

    Unlock-ADAccount $User

    $User = Get-ADUser $User -properties LockedOut

    #Confirms account has been successfully unlocked
    if (!$User.LockedOut) {
        write-host ""
        write-host "Account"$User.SamAccountName"has been unlocked" -backgroundcolor DarkGreen -ForegroundColor White
    }

}

else {
    write-host "No locked accounts found"
    write-host ""
}