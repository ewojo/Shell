#Disable User Account
Import-Module ActiveDirectory

$USERNAME=Read-Host "Enter the account name to disable"

Disable-ADAccount -identity $USERNAME

Write-Host "Account has been disabled for $USERNAME"
