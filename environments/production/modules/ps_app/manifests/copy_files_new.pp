class ps_app::copy_files_new{
  
  $directories = ["c:\\ps","c:\\ps\\service","c:\\ps\\logs"]
  ps_common::create_directories {'myservice':
    directoryArray => $directories,
    before         => Unzip['wcf.zip']
  }

  file { 'c:\\temp\\wcf.zip':
    ensure             => file,
    source             => 'puppet:///modules/ps_app/wcf.zip',
    source_permissions => ignore,
  }

  unzip { 'wcf.zip':
      source  => "C:\\temp\\wcf.zip",
      creates => "C:\\ps\\service\\NorthWind.console.exe",
      require => File['c:\\temp\\wcf.zip'],
  }
}