$service = Get-WmiObject win32_service | Where {$_.name -eq '<%= @servicename %>'}
if(-Not $service){exit 0} # don't need to do anything when there is no service
$ServiceStartMode = $service.startmode
if($ServiceStartMode -ne '<%= @ps_service_mode %>') {throw "servicemode is $ServiceStartMode, but need to be <%= @ps_service_mode %>"}