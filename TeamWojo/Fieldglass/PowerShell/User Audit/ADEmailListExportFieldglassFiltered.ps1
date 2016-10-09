###############################################
#
#     Active Directory Email Export
#     Made By Eric Wojtowicz
#     Date 3/23/2016
#     (Filters Users with @Fieldglass.com emails) 
#
###############################################
Import-Module ActiveDirectory
Get-ADUser -Filter {(emailaddress -notlike "*@sap.com*" ) -and (enabled -ne $false)}  -SearchBase “OU=Fieldglass,DC=Fieldglass,DC=COM” -Properties * |  
    select -Property Name,DisplayName,mail,SamAccountName |
    Sort-Object -Property SamAccountName |
    export-CSV C:\TEST\FieldglassEmailInAD.csv