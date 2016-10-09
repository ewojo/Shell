###############################################
#
#     Active Directory Email Export
#     Made By Eric Wojtowicz
#     Date 3/23/2016
#
###############################################
Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase “OU=Fieldglass,DC=Fieldglass,DC=COM” -Properties * | 
    select -Property Name,DisplayName,mail,SamAccountName |
    Sort-Object -Property SamAccountName |
    export-CSV C:\TEST\AllEmailsinAD.csv