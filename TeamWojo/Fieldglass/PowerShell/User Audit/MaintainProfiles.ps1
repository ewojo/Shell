<#
    This script shows a list of user profiles on the specified computer. It has the option to limit the profiles shown to 10 as it can take a while to calculate the profile sizes of all user profiles on a computer.
    The script should be run as an administrator to ensure it has permissions to access user profiles.

    To Do:
    Add option to delete profiles
#>


function Get-FolderSize ($Path, $ComputerName) {
#Returns the total size of all files in the folder specified (inluding subfolders) in megabytes.
        
    if ($ComputerName) {
        $FolderSize = invoke-command -cn $ComputerName -ScriptBlock {Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Sum Length}
    }
    else {
        $FolderSize = Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Sum Length
    
    }

    $FolderSize = $FolderSize.Sum / 1048576
    $FolderSize = "{0:N2}" -f $FolderSize 
    $FolderSize

}

function Get-ProfileDetails ($ComputerName, $Oldest) {

    #Gets all profiles on the computer
    if ($Oldest) {
        if ($ComputerName) {
            $profiles = Get-CimInstance win32_userprofile -ComputerName $ComputerName | sort LastUseTime -des | select LastUseTime, SID, LocalPath -Last $Oldest
        }
        else {
            $profiles = Get-CimInstance win32_userprofile | sort LastUseTime -des | select LastUseTime, SID, LocalPath -Last $Oldest
        }
    }
    else {

        if ($ComputerName) {
            $profiles = Get-CimInstance win32_userprofile -ComputerName $ComputerName | select LastUseTime, SID, LocalPath
        }
        else {
            $profiles = Get-CimInstance win32_userprofile | select LastUseTime, SID, LocalPath
        }
        
    }


    #Loops through each profile and finds and adds AccountName and FolderSize properties
    foreach ($profile in $profiles) {


        $SID = $profile.SID
        $AccountName = ([wmi]"win32_SID.SID='$SID'").AccountName

        $profile | Add-Member -MemberType NoteProperty -Name AccountName -Value $AccountName


        write-host "Calculating profile size for user:" $AccountName
        $profile | Add-Member -MemberType NoteProperty -Name FolderSize -Value (Get-FolderSize -Path $profile.LocalPath)


    }
    
    $Profiles | Format-Table AccountName, LocalPath, FolderSize, LastUseTime
}


function Show-Menu {

    clear-host

    $ComputerName = read-host "Please enter a computer name or press enter to get profiles on this computer"

    if ($ComputerName) {

        $profiles = Get-CimInstance win32_userprofile -ComputerName $ComputerName

    }
    else {
        $profiles = Get-CimInstance win32_userprofile
    }

    write-host "There are"$profiles.Count"profiles on this computer. Depending on the number of profiles / files it may take a while to calculate the size of all profiles"
    write-host
    write-host "---------------------------------------------------"
    write-host "Please choose an option:"
    write-host
    write-host "1. Top 10 profiles with oldest last use date"
    write-host "2. All Profiles"
    write-host
    write-host "0. Exit"
    write-host "---------------------------------------------------"

    $ans = Read-Host

    switch ($ans) {

        1 {Get-ProfileDetails -Oldest 10 -ComputerName $ComputerName}
        2 {Get-ProfileDetails}

        0 {break}

    }


}

Show-Menu