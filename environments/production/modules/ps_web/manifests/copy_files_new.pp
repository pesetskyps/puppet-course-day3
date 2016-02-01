class ps_web::copy_files_new{
  $directories = ["c:\\ps","c:\\ps\\site","c:\\ps\\logs"]
  ps_common::create_directories {'mysite':
    directoryArray => $directories,
    before         => Unzip['web.zip']
  }

  file { 'c:\\temp\\web.zip':
    ensure             => file,
    source             => 'puppet:///modules/ps_web/web.zip',
    source_permissions => ignore,
  }
  unzip { 'web.zip':
      source  => "C:\\temp\\web.zip",
      creates => "C:\\ps\\site\\web.config",
  }
}