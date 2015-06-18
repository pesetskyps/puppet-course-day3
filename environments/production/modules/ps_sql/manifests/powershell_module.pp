class ps_sql::powershell_module(){
  #install SharedManagementObjects
  $sharedManagementObjects_package_name = 'SharedManagementObjects.msi'
  $sharedManagementObjects_local_path = "c:\\temp\\${sharedManagementObjects_package_name}"
  $sharedManagementObjects_puppet_path = "puppet:///modules/ps_sql/${sharedManagementObjects_package_name}"

  #Copy source files
  file { $sharedManagementObjects_local_path:
    ensure             => 'present',
    source             => $sharedManagementObjects_puppet_path,
    source_permissions => ignore,
  }
  #install
  package { 'Microsoft SQL Server 2014 Management Objects  (x64)':
    ensure          => '12.0.2000.8',
    source          => $sharedManagementObjects_local_path,
    install_options => [ '/quiet'],
    require         => [File[$sharedManagementObjects_local_path],Class['mssql']]
  }

  #install powershell module
  $powerShellTools_package_name = 'PowerShellTools.msi'
  $powerShellTools_local_path = "c:\\temp\\${powerShellTools_package_name}"
  $powerShellTools_puppet_path = "puppet:///modules/ps_sql/${powerShellTools_package_name}"

  #Copy source files
  file { $powerShellTools_local_path:
    ensure             => 'present',
    source             => $powerShellTools_puppet_path,
    source_permissions => ignore,
  }
  #install
  package { 'Windows PowerShell Extensions for SQL Server 2014 ':
    ensure          => '12.0.2000.8',
    source          => $powerShellTools_local_path,
    install_options => [ '/quiet'],
    require         => [File[$powerShellTools_local_path], Package['Microsoft SQL Server 2014 Management Objects  (x64)']]
  }
}