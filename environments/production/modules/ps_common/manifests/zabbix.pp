define fluxcommon::zabbix ($zabbix_server_ip) {
  # This class uses variables from site.pp to define share
  case $operatingsystem {
    'windows' : {
      $zabbix_puppet_path   = 'puppet:///modules/fluxcommon/zabbix/zabbix_agent'
      $zabbix_package_name  = 'zabbix_agentd.exe'
      $zabbix_path          = 'C:\\Program Files\\zabbix'
      $zabbix_config        = "${zabbix_path}\\zabbix_agentd.conf"
      $ps_check_service = 'if($(get-service *zabbix*)) {exit 0} else {exit 1}'
      #Copy Zabbix files
      file {  $zabbix_path:
        ensure             => directory,
        source             => $zabbix_puppet_path,
        recurse            => true,
        source_permissions => ignore,
      }
      #Create config file
      file { $zabbix_config:
        path               => $zabbix_config,
        ensure             => file,
        require            => File[$zabbix_path],
        notify             => Service['Zabbix Agent'],
        content            => regsubst(template('fluxcommon/zabbix_conf.erb'), '\n', "\r\n", 'EMG'),
        source_permissions => ignore,
      }
      #Install zabbix
      #Check whether service installed (unless)
      exec { $zabbix_package_name:
        command => "C:\\Windows\\system32\\cmd.exe /c cd ${zabbix_path} & ${zabbix_package_name} --config zabbix_agentd.conf --install",
        require => File[$zabbix_config],
        unless  => "${powershell} ${ps_check_service}"
      }
      service { 'Zabbix Agent':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Exec[$zabbix_package_name],
      }
    }
    'centos' : {
      class { 'selinux':
        mode => 'disabled'
      }
      package { 'zabbix':
        ensure  => present,
        require => Yumrepo['zabbixrpm'],
      }
      yumrepo {'zabbixrpm':
        baseurl         => 'http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/',
        enabled         => 1,
        descr           => 'whatever',
        metadata_expire => '300',
        gpgcheck        => 'No',
      }
      package { 'zabbix-agent':
        ensure  => present,
        require => Package['zabbix'],
      }
      service { 'zabbix-agent':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => Package['zabbix-agent'],
      }
      # Configuration
      file { '/etc/zabbix/zabbix_agentd.conf':
        content => template('fluxcommon/zabbix_conf_centos.erb'),
        notify  => Service['zabbix-agent'],
        require => Package['zabbix-agent'],
      }
      firewall { '110 zabbix-agent':
        port   => [10050],
        proto  => tcp,
        action => accept,
      }
    }
  }
}
