
clear-host
# Import active directory module for running AD cmdlets
Import-Module activedirectory

    # Allow user to enter location of file
    # Write-Host "Please enter the location of your file: "
    # $CSVLocation = Read-Host

# Import CSV from location given
# C:\Users\i842548\Desktop\adusers.csv
$ADUsers = Import-csv C:\stuff\adusers.csv

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers)
{
    # Read user data from each field in each row and assign the data to a variable as below

    $Username  = $User.username
    $Password  = $User.password
    $Firstname = $User.firstname
    $Lastname  = $User.lastname
    $OU        = $User.ou # This field refers to the OU the user account is to be created in
    $Title     = $User.title


    # Check to see if the user already exists in AD
    if (Get-ADUser -F {sAMAccountName -eq $Username})
    {
        # If user does exist, give a warning
        Write-Warning "A user account with $Username already exists in Active Directory"
        #Continue with next user on the list
        continue 
    }

    # User does not exist then proceed to create the new user account
    
    #Find a user with the same title as the new user to copy group membership from
    $UserToCopy = Get-ADUser -F {Title -eq $Title} -Properties MemberOf


    # Account will be created in the OU provided by the $OU variable read from the CSV file


   
    New-ADUser `
        -sAMAccountName $Username `
        -UserPrincipalName $Username@fgdevopslab.local `
        -Name "$Firstname $Lastname" `
        -GivenName $Firstname `
        -Surname $Lastname `
        -Enabled $True `
        -DisplayName "$Firstname $Lastname" `
        -Path $OU `
        -AccountPassword (convertto-securestring $Password -AsPlainText -Force) `
        -Title $Title

        

    # Make user create password at first logon
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true

    #Copy group membership to new user if there are groups to copy
    if ($UserToCopy.MemberOf.Count -gt 0) {
        $UserToCopy.MemberOf | Add-ADGroupMember -Members $Username
    }

}