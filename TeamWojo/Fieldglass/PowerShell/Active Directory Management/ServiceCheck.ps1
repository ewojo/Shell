<#
Checks the current CPU usage for the process specified and gives the option to restart the service specified.
#>

function CheckProcessCPU ($Process2Check) {

    $Counters = Get-Counter "\Process($Process2Check)\% Processor Time" -ComputerName $Computer
    $CPUCount = (Get-WMIObject Win32_ComputerSystem -ComputerName $Computer).NumberOfLogicalProcessors

    write-host "CPU Usage"

    foreach ($Counter in $Counters.CounterSamples) {

        #Calculates total CPU usage percentage based on the number of logical processors
        $PercentCPU = $Counter.CookedValue / $CPUCount
        
        write-host $Counter.InstanceName":" $PercentCPU "%"
    }

}

function RestartService ($Service2Restart) {
    $ans = read-host "Restart"$Service2Restart"? (y/n)"
    if ($ans -eq "y") {
        write-host "Stopping "$Service2Restart
        #Stops the service
        Get-Service -Name $Service2Restart -ComputerName $Computer | stop-service
        write-host "Starting "$Service2Restart
        #Starts the service
        Get-Service -Name $Service2Restart -ComputerName $Computer| start-service
        #Displays the status of the service
        Get-Service -Name $Service2Restart -ComputerName $Computer
        
    }
}

$Computer = read-host "Enter computer name to check/restart service on"
$Service2Restart = "insiteprod1"
$Process2Check = "java"

CheckProcessCPU $Process2Check
RestartService $Service2Restart


