import-module "C:\Program Files\Microsoft SQL Server\120\Tools\PowerShell\Modules\sqlps"
invoke-sqlcmd -Query 'use Northwind;select top 1 * from orders' -ServerInstance <%= @instance %> -ErrorAction Stop -username "sa" -password "Zabbix_2015"
