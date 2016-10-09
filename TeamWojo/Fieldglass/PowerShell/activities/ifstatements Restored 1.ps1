
$serviceName         = 'AdobeARMService'
$service             = Get-Service -Name $ServiceName
$serviceNotification = $true
$serviceState        = $null

Write-Host "`n***** EXAMPLE 01: IF...ELSEIF...ELSE w/ MULTIPLE CONDITIONS *****`n"

if (($serviceNotification -eq $true) -and ($service.Status -eq 'Running'))
{
   $serviceState = $service.Status
   Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)  
   Stop-Service -Name $serviceName -Force -Verbose
   Start-Sleep -Milliseconds 10000
   $service          = Get-Service -Name $ServiceName
   Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)
  
}
elseif($service.Status -eq 'Stopped')
{

    $serviceState = $service.Status
    Start-Service -Name $serviceName -Verbose
    Start-Sleep -Milliseconds 10000
    $service        = Get-Service -Name $ServiceName 
    Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)


}
else
{

    Write-Host ("Something happened . . . ")


}


if (($serviceNotification -eq $true) -and ($service.Status -eq 'Stopped'))
{

    $serviceState = $service.Status
    Start-Service -Name $serviceName -Verbose
    Start-Sleep -Milliseconds 10000
    $service        = Get-Service -Name $ServiceName 
    Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)

}
else
{

    Write-Host ("Something happened in our second IF...ELSE block . . . ")


}


Write-Host "`n***** EXAMPLE 02: SWITCH *****`n"


switch($serviceState)
{

        'Running'
        {
         
             $serviceState = $service.Status
             Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)  
             Stop-Service -Name $serviceName -Force -Verbose
             Start-Sleep -Milliseconds 10000
             $service          = Get-Service -Name $ServiceName
             Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)

         }

         'Stopped'
         {

             $serviceState = $service.Status
             Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)  
             Stop-Service -Name $serviceName -Force -Verbose
             Start-Sleep -Milliseconds 10000
             $service          = Get-Service -Name $ServiceName
             Write-Host ("Service Notifications are set to true and will trigger for " + $service.DisplayName + ". The state of the service is: " + $service.Status)

          }
}