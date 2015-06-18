$service = Get-WmiObject win32_service | Where {$_.name -eq '<%= @servicename %>'}
if(-Not $service){exit 0} # don't need to do anything when there is no service
$ServiceUser = $service.startname
if($ServiceUser -ne '<%= @username %>') {throw "user is $ServiceUser, but need to be <%= @username %>"}