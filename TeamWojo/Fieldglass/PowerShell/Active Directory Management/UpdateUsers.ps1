<#
This script updates the department, title and manager for users based on what is in the csv
#>

import-module ActiveDirectory

$Users = import-csv "C:\temp\Users2Update.csv"


foreach ($User in $Users) {
    $Filter = 'Name -eq "'+$User.Name+'"'

    #Gets the ADUser object for the user
    $ADUser = Get-ADUser -Filter $filter -properties Department,Title
    $Filter  = 'Name -eq "'+$User.'New Manager'+'"'

    #Gets the ADUser object for the user's manager
    $Manager = Get-ADUser -Filter $filter

    #Sets the new details for the user
    Set-ADUser $ADUser -Department $User.'New Department' -Title $User.'New Title' -Manager $Manager
    
}