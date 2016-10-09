Import-Module ActiveDirectory
# Set the new password
$newPassword = ConvertTo-SecureString -AsPlainText "P@$$w0rd!" -Force
Set-ADAccountPassword -Identity Voytovitz -NewPassword $newPassword -Reset