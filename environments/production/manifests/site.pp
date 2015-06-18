$powershell = 'C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy RemoteSigned -noprofile -nologo -noninteractive -command'

node default {
  include common
  include ps_web::iis
  include ps_web::mysite

  class {'ps_app::myservice':
    username => 'LocalSystem',
    pass => '\"\"',
  }
  include ps_app::myservice_config
  include ps_sql::sqlexpress
  class {'ps_sql::fill_northwind_db':
    instance => "$hostname"
  }

  Class['ps_app::myservice'] -> Class['ps_app::myservice_config']
}
