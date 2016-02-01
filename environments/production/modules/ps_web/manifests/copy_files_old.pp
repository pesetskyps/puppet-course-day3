class ps_web::copy_files_old{
  file { "C:\\ps":
    ensure            => directory,
    source_permissions => ignore,
  }
  file { "C:\\ps\\site":
    ensure            => directory,
    source_permissions => ignore,
    require           => File["C:\\ps"]
  }

  file { 'c:\\temp\\web.zip':
    ensure             => file,
    source             => 'puppet:///modules/ps_web/web.zip',
    source_permissions => ignore,
  }
  unzip { 'web.zip':
      source  => "C:\\temp\\web.zip",
      creates => "C:\\ps\\site\\web.config",
      require => [File["C:\\ps\\site"],File['c:\\temp\\web.zip']]
  }
}