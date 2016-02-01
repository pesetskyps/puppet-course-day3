define fluxcommon::nxlog($environment, $system) {
  $nxlog_package_name = 'nxlog-ce-2.8.1248.msi'
  $nxlog_config = "c:\\Program Files (x86)\\nxlog\\conf\\nxlog.conf"
  $nxlog_local_path = "c:\\temp\\${nxlog_package_name}"
  $nxlog_puppet_path = "puppet:///modules/fluxcommon/nxlog/${nxlog_package_name}"

case $system
  {
    'cus' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.cus.erb'}
    'daapi' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.daapi.erb'}
    'www tracking widgets3' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.www_tracking_widgets3.erb'}
    'fluxstatic cdn wdk4 activity_widgets4_static' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.fluxstatic_cdn_wdk4_activity_widgets4_static.erb' }
    'activity' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.activity.erb'}
    'moderation' : { $nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.moderation.erb'}
    'ugc' : { $nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.ugc.erb'}
    'rtx' : { $nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.rtx.erb'}
    'captcha' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.captcha.erb'}
    'rtxsupport act_service' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.rtxsupport_act_service.erb' }
    'sql' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.sql.erb'}
    'jmeter' : {$nxlogtemplate_puppet_path='fluxcommon/nxlog/nxlog.conf.jmeter.erb' }
    default : {
      notify {"System is not specified. Please verify it is set to 'cus','daapi','www tracking widgets3','fluxstatic cdn wdk4 activity_widgets4_static','activity','moderation','ugc','rtx','captcha','rtxsupport act_service','sql','jmeter'":loglevel => err,}
    }
  }

  #Copy source files
  file { $nxlog_local_path:
    ensure             => 'present',
    source             => $nxlog_puppet_path,
    source_permissions => ignore,
    owner              => 'Administrators',
    group              => 'Administrators',
  }
  #install
  package { 'NXLOG-CE':
    ensure          => '2.8.1248',
    source          => $nxlog_local_path,
    require         => File[$nxlog_local_path],
    install_options => ['/q'],
  }

  # Edit config
  file { $nxlog_config:
    path               => $nxlog_config,
    ensure             => file,
    require            => Package['NXLOG-CE'],
    source_permissions => ignore,
    #content => regsubst(template("$nxlogtemplate_puppet_path"), '\n', "\r\n", 'EMG'),
    content            => template($nxlogtemplate_puppet_path),
  }
}
