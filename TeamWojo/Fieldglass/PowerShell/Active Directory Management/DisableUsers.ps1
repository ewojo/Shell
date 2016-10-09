Import-Module activedirectory

$list = Import-CSV c:\scripts\disableusers.csv

forEach ($item in $list) {

$INumber = $item.I-Number

Disable-ADAccount -Identity $Inumber
}