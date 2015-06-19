class ps_app::myservice($username,$pass,$connectionstring){
  # include ps_app::copy_files_old
  include ps_app::copy_files_new

  $servicename = 'myservice'
  $ps_service_mode = 'auto'
  $local_myserviceservice_path = 'C:\ps\service\NorthWind.console.exe'

  #create windows service
  exec { "Install_${servicename}":
    command => "C:\\Windows\\system32\\cmd.exe /c sc create ${servicename} binPath= \"${local_myserviceservice_path}\"",
    # require => Class['ps_app::copy_files_old'],
    require => Class['ps_app::copy_files_new'],
    unless  => template('ps_app/powershell/check_service.ps1'),
    provider => powershell,
  }

  #Set user service will run from
  exec { "Set_user_${servicename}":
    command => "C:\\Windows\\system32\\cmd.exe /c sc.exe config ${servicename} obj= ${username} password= ${pass}",
    require => Exec["Install_${servicename}"],
    unless  => template('ps_app/powershell/check_service_login.ps1'),
    provider => powershell,
  }

  #Set mode service will run
  exec { "Set_startmode_${servicename}":
    command => "C:\\Windows\\system32\\cmd.exe /c sc.exe config ${servicename} start= ${ps_service_mode}",
    require => Exec["Install_${servicename}"],
    provider => powershell,
    unless  => template('ps_app/powershell/check_service_mode.ps1'),
    logoutput => "on_failure",
  }

  file { "myservice_config_app_config":
    path               => "c:\\ps\\service\\NorthWind.console.exe.config",
    ensure        => file,
    # content             => regsubst(template($config_values['puppet_template_path']), '\n', "\r\n", 'EMG'),
    content             => template('ps_app/NorthWind.console.exe.config.erb'),
    require => Class['ps_app::copy_files_new']
    # require => Class['ps_app::copy_files_old']
    source_permissions  => ignore,
  }

  #ensure service is always running
  service {$servicename :
    ensure => running,
    require => Exec["Set_user_${servicename}"],
    subscribe => File["myservice_config_app_config"]
  }
}
