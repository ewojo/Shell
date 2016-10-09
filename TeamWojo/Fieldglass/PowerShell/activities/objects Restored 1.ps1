# Make Variable into Object
$A

#Empty shell to store an object in

#Create a Number Object

$A = 1

#Create a Text Object

$A = "TEST"

#Store Time to turn into "Date and Time Object"
$A = Get-Date

#Methods and Properties

Get-Member -InputObject $a

#Type Of Object
    #Methods
    #Properties
#Methods - Syntax ()

($A).AddDays(1)

#Properties

($A).Date

#Breakdown


($A).Day
($A).DayOfWeek
($A).DayOfYear

