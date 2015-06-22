class ps_web::iis{

  #Install IIS-Role and features from answer file
  dism {'IIS-WebServer':
    ensure => present,
    all    => true
  }

  dism {['IIS-StaticContent','IIS-ASPNET45',]:
    ensure  => present,
    all     => true,
    require => Dism['IIS-WebServer']
  }
  dism {'IIS-HttpErrors':
    ensure => present,
    all    => true
  }
}
