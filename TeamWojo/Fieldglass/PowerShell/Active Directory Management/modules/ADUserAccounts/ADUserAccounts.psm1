function Get-UsersWithMissingInfo {
    Get-ADUser -LDAPFilter "(!physicalDeliveryOfficeName=*)" -searchBase "OU=Superusers,DC=fgdevopslab,DC=local" `
        | Select Name
}

function New-UsersFromCSV ($CSVLocation) {

    #Prompt for CSV location is it hasn't been passed to the function
    if ($CSVLocation -eq $null) {
        $CSVLocation = read-host "Please enter path the CSV file for import"
    }


    # Import CSV from location given
    $ADUsers = Import-csv $CSVLocation

    # Loop through each row containing user details in the CSV file
    foreach ($User in $ADUsers)
    {
        # Read user data from each field in each row and assign the data to a variable as below

        $Username  = $User.username
        $Password  = $User.password
        $Firstname = $User.firstname
        $Lastname  = $User.lastname
        $Department  = $user.department
        $Description = $user.title
        $Office      = $user.seat
        $Manager     = $user.manager
        $title       = $user.title
        $OU        = $User.ou # This field refers to the OU the user account is to be created in


        # Check to see if the user already exists in AD
        if (Get-ADUser -F {sAMAccountName -eq $Username})
        {
            # If user does exist, give a warning
            Write-Warning "A user account with $Username already exists in Active Directory"
        }
        else
        {
            # User does not exist then proceed to create the new user account

            # Account will be create in the OU provided by the $OU variable read from the CSV file
            New-ADUser `
                -sAMAccountName $Username `
                -UserPrincipalName $Username@fgdevopslab.local `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $True `
                -DisplayName "$Firstname $Lastname" `
                -Department $Department `
                -Description $Description `
                -Title $Title `
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
        }
        # Make user create password at first logon
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true

    # *** From here, we add a check to look at the description/job title (have to add) and 
    # then add the user to those groups we have specified. ***
    }

}


function New-AdminsFromCSV ($CSVLocation) {

    #Prompt for CSV location is it hasn't been passed to the function
    if ($CSVLocation -eq $null) {
        $CSVLocation = read-host "Please enter path the CSV file for import"
    }

    # Import CSV from location given
    $ADUsers = Import-csv $CSVLocation

    # Loop through each row containing user details in the CSV file
    foreach ($User in $ADUsers)
    {
        # Read user data from each field in each row and assign the data to a variable as below

        $Username  = $User.username
        $Password  = $User.password
        $Firstname = $User.firstname
        $Lastname  = $User.lastname
        $OU        = $User.ou # This field refers to the OU the user account is to be created in

        # Check to see if the user already exists in AD
        if (Get-ADUser -F {SamAccountName -eq $Username})
        {
            # If user does exist, give a warning
            Write-Warning "A user account with $Username already exists in Active Directory"
        }
        else
        {
            # User does not exist then proceed to create the new user account

            # Account will be create in the OU provided by the $OU variable read from the CSV file
            New-ADUser `
                -sAMAccountName $Username `
                -UserPrincipalName $Username@fgdevopslab.local `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $True `
                -DisplayName "$Firstname $Lastname" `
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
        }
        # Make user create password at first logon
        Set-ADUser -Identity $Username -ChangePasswordAtLogon $true
        Add-ADGroupMember -Identity Administrators -Member $Username
    }
}

function Set-UserInfoFromCSV ($CSVLocation) {

    #Prompt for CSV location is it hasn't been passed to the function
    if ($CSVLocation -eq $null) {
        $CSVLocation = read-host "Please enter path the CSV file for import"
    }

    # Import CSV from location given
    $ADUsers = Import-csv $CSVLocation

    # Loop through each row containing user details in the CSV file
    foreach ($User in $ADUsers)
    {
        # Read user data from each field in each row and assign the data to a variable as below

        $Username  = $User.username
        $Password  = $User.password
        $Firstname = $User.firstname
        $Lastname  = $User.lastname
        $Department  = $user.department
        $Description = $user.title
        $Office      = $user.seat
        $Manager     = $user.manager
        $title       = $user.title
        $OU        = $User.ou # This field refers to the OU the user account is to be created in

        # Check to see if the user exists in AD
        if (Get-ADUser -F {SamAccountName -eq $Username})
        {
            # If user does not exist, notify and ask for creation
            Write-Warning "User does not exist. Do you want to create a new user?"
            $selection = Read-Host

            # If "y", create account
            if($selection -eq "y")
                {
                    Add-ADUser `
                -sAMAccountName $Username `
                -UserPrincipalName $Username@fgdevopslab.local `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $True `
                -DisplayName "$Firstname $Lastname" `
                -Department $Department `
                -Description $Description `
                -Title $Title `
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
                }
            else
            {
                Write-Host "User not created."
            }
        }
        else
        {
            # Account will be modified with the info from the CSV file
            Set-ADUser `
                -sAMAccountName $Username `
                -UserPrincipalName $Username@fgdevopslab.local `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $True `
                -DisplayName "$Firstname $Lastname" `
                -Department $Department `
                -Description $Description `
                -Title $Title `
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
        }
    }
}

#Unlock AD Users account with prompt
function Unlock-ADAccountPrompt {

    $USERNAME=Read-Host "Enter the account name to unlock"

    Unlock-ADAccount -identity $USERNAME

    Write-Host "Account is unlocked for $USERNAME"

}


#Disable User Account with prompt
function Disable-ADAccountPrompt {

    $USERNAME=Read-Host "Enter the account name to disable"

    Disable-ADAccount -identity $USERNAME

    Write-Host "Account has been disabled for $USERNAME"

}

function Export-GroupMembership {

    #Export Users in Group to CSV
    
    #Let User Set Location
    Write-Host "Please enter the location to export CSV File & CSV FileName (i.e. C:Temp\group.csv)"
    $CSVLocation = Read-Host

    #Group to Export
    Write-Host "Please Enter Group to Export"
    $ADGroup = Read-Host

    $Group = Get-ADGroupMember -identity “$ADGroup” -Recursive
    $Group | get-aduser -Properties emailaddress | select name,samaccountname,emailaddress |export-csv -path $CSVLocation

}

function Show-Menu {

    #Shows available functions in the module and allows the user to choose which function to use
    clear-host

    write-host "Functions available in this module"

    write-host "---------------------------------------------------"
    write-host ""
    write-host "1. Get-UsersWithMissingInfo - " -NoNewLine
    write-host "Displays the name of users that have no 'office' set in AD" -BackgroundColor DarkGreen
    write-host "2. New-UsersFromCSV - " -NoNewLine
    write-host "Creates new users from details in a CSV file" -BackgroundColor DarkGreen
    write-host "3. New-AdminsFromCSV - " -NoNewLine
    write-host "Creates new admin users from details in a CSV file" -BackgroundColor DarkGreen
    write-host "4. Set-UserInfoFromCSV - " -NoNewLine
    write-host "Updates existing users using details in a CSV file" -BackgroundColor DarkGreen
    write-host "5. Unlock-ADAccountPrompt - " -NoNewLine
    write-host "Unlocks a user account" -BackgroundColor DarkGreen
    write-host "6. Disable-ADAccountPrompt - " -NoNewLine
    write-host "Disables a user account" -BackgroundColor DarkGreen
    write-host "7. Export-GroupMembership - " -NoNewLine
    write-host "Exports the members of a group to a CSV file" -BackgroundColor DarkGreen
    write-host "0. Exit"
    write-host ""
    write-host "---------------------------------------------------"

    $ans = read-host "Please select an option"
    
    switch ($ans) {

        1 {Get-UsersWithMissingInfo}
        2 {New-UsersFromCSV}
        3 {New-AdminsFromCSV}
        4 {Set-UserInfoFromCSV}
        5 {Unlock-ADAccountPrompt}
        6 {Disable-ADAccountPrompt}
        7 {Export-GroupMembership}
        0 {break}

    }

}