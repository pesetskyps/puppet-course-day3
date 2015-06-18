import-module "C:\Program Files\Microsoft SQL Server\120\Tools\PowerShell\Modules\sqlps"
invoke-sqlcmd -InputFile "<%= @file_db_create%>" -ServerInstance <%= @instance %> -ErrorAction Stop -username "sa" -password "Zabbix_2015"
