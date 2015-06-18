class ps_web::mysite
{

  #deploy the site files
  include ps_web::copy_files_old
  # include ps_web::copy_files_new

  #creates iis application pool
  iis_apppool {'PuppetIisDemo':
    ensure                    => present,
    managedpipelinemode       => 'Integrated',
    managedruntimeversion     => 'v4.0',
    enable32bitapponwin64     =>  $enable32app,
    processmodel_identitytype => 'NetworkService',
    queuelength               => '10000',
  }

  #creates iis site
  iis_site {'mysite':
    ensure                  => present,
    serverautostart         => true,
    id                      => '10',
    bindings                => ['http/*:25999:'],
    logfile_enabled         => true,
    logfile_logformat       => 'W3C',
    logfile_period          => 'Hourly',
    logfile_directory       => 'C:\ps\logs\iis',
    logfile_logextfileflags => 'Date, Time, ClientIP, UserName, ServerIP, Method, UriStem, UriQuery, HttpStatus, TimeTaken, ServerPort, UserAgent, Referer, Host',
    require                 => Iis_apppool['PuppetIisDemo']
  }

  #creates iis application inside the site
  iis_app {'mysite/':
    ensure          => present,
    applicationpool => 'PuppetIisDemo',
    require         => Iis_site['mysite']
  }

  #creates the virtual directory inside site that maps the iis hierarchy to fodler hierarchy
  iis_vdir {'mysite/':
    ensure       => present,
    iis_app      => 'mysite/',
    physicalpath => 'C:\ps\site',
    require      => Iis_app['mysite/']
  }
}
