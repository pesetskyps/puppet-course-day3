class ps_app::myservice_config{
	file { "myservice_config_app_config":
		path               => "c:\\ps\\service\\NorthWind.console.exe.config",
		ensure 				=> file,
		# content            	=> regsubst(template($config_values['puppet_template_path']), '\n', "\r\n", 'EMG'),
		content            	=> template('ps_app/NorthWind.console.exe.config.erb'),
		source_permissions 	=> ignore,
	}
}