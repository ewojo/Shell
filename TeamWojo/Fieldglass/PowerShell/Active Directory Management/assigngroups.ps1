Import-Module ActiveDirectory

# Allow user to enter what description of user to move
Write-Host "Please enter the description (Movies, Music, Games) to move users to the assigned group:"
$description = Read-Host

# Begin if/else logic to determine who to move and where
if ($description -eq "Movies")
{
    $user = Get-ADUser -SearchBase 'OU=Minions,DC=fgdevopslab,DC=local' -filter {Description -eq "Movie Star"}
    Add-ADGroupMember -Identity Movies -Member $user
    # Write-Host "$user is now a member of Movies."
}
    elseif ($description -eq "Music")
    {
        $user = Get-ADUser -SearchBase 'OU=Minions,DC=fgdevopslab,DC=local' -filter {Description -eq "Musician"}
        Add-ADGroupMember -Identity Music -Member $user
        # Write-Host "$user is now a member of Movies."
    }
        elseif ($description -eq "Games")
        {
            $user = Get-ADUser -SearchBase 'OU=Minions,DC=fgdevopslab,DC=local' -filter {Description -eq "Game Character"}
            Add-ADGroupMember -Identity Games -Member $user
            # Write-Host "$user is now a member of Movies."
        }
            else
            {
                Write-Host "Wrong input."
            }