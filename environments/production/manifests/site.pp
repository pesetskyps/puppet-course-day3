$powershell = 'C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy RemoteSigned -noprofile -nologo -noninteractive -command'

node default {
  include common
  include ps_web::iis
  include ps_web::mysite

  class {'ps_app::myservice':
    username => 'LocalSystem',
    pass => '\"\"',
    connectionstring => 'data source=localhost,1433;initial catalog=Northwind;User Id=sa; password=Zabbix_2015;'
  }

  include ps_sql::sqlexpress
  class {'ps_sql::fill_northwind_db':
    instance => "$hostname"
  }
}
