function Get-UsersWithMissingInfo {
    Get-ADUser -LDAPFilter "(!physicalDeliveryOfficeName=*)" -searchBase "OU=Superusers,DC=fgdevopslab,DC=local" `
        | Select Name
}

function New-UsersFromCSV ($CSVLocation) {
        # Allow user to enter location of file
        # Write-Host "Please enter the location of your file: "
        # $CSVLocation = Read-Host

    # Import CSV from location given
    # C:\Users\i842548\Desktop\adusers.csv
    #$ADUsers = Import-csv C:\Users\i842548\Desktop\adusers.csv
    $ADUsers = Import-csv $CSVLocation

    # Loop through each row containing user details in the CSV file
    foreach ($User in $ADUsers)
    {
        # Read user data from each field in each row and assign the data to a variable as below

        $Username  = $User.username
        $Password     = $User.password
        $Firstname   = $User.firstname
        $Lastname    = $User.lastname
        $Department  = $user.department
        $Description = $user.title
        $Office      = $user.seat
        $Manager     = $user.manager
        $title       = $user.title
        $OU          = $User.ou # This field refers to the OU the user account is to be created in

        # *** We also need to add additional fields (description/job title) in the bulk CSV upload if
        # we want to be able to do this all in one script/module ***

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

function Set-UserInfoFromCSV {

    # Allow user to enter location of file
    Write-Host "Please enter the location of your file: "
    $CSVLocation = Read-Host

    # Import CSV from location given
    # C:\Users\i842548\Desktop\adusers.csv
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
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
        }
    }
}