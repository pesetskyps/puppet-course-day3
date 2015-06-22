class common(){
  file { 'c:/temp/test' :
    ensure             => directory,
    source_permissions => ignore,
  }

  net_share {'PuppetTest':
      ensure  => present,
      path    => 'c:\temp\test',
      require => File['c:/temp/test']
  }

  acl { 'c:/temp/test':
    permissions                => [
      { identity      => 'Everyone',
        rights        => ['read'] },
      { identity      => 'Administrators',
        rights        => ['full'] }
    ],
    purge                      => true,
    inherit_parent_permissions => false,
    require                    => File['c:/temp/test']
  }
}
