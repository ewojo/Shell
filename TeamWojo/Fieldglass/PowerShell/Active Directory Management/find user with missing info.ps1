Get-ADUser -LDAPFilter "(!physicalDeliveryOfficeName=*)" -searchBase "OU=Superuser,DC=fgdevopslab,DC=local" `
    | Select Name