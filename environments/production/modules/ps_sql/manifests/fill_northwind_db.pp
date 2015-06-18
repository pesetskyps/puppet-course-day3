#this is pwoershell module
class ps_sql::fill_northwind_db($instance){
  $file_db_create = "c:\\temp\\instnwnd.sql"
  file { $file_db_create:
    ensure           => 'present',
    source           => 'puppet:///modules/ps_sql/instnwnd.sql',
    source_permissions => ignore,
  }
  exec { 'create_northwind_db':
    command =>  template('ps_sql/powershell/create_northwind_database.ps1'),
    require => [File[$file_db_create],Class['ps_sql::powershell_module']],
    unless  =>  template('ps_sql/powershell/check_dabatase_exist.ps1'),
    provider => powershell,
  }
}
