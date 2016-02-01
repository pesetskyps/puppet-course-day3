class ps_app::copy_files_old{
  #set up servicedirectory
  file { 'C:\ps':
   ensure            => directory,
   source_permissions => ignore,
  }
  file { 'C:\ps\service':
   ensure            => directory,
   source_permissions => ignore,
   require           => File['C:\ps']
  }

  file { 'c:\\temp\\wcf.zip':
    ensure             => file,
    source             => 'puppet:///modules/ps_app/wcf.zip',
    source_permissions => ignore,
  }

  unzip { 'wcf.zip':
      source  => 'C:\temp\wcf.zip',
      creates => $local_myserviceservice_path,
      require => [File['c:\\temp\\wcf.zip'],File['C:\ps\service']],
  }
}