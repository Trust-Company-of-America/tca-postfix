class postfix::contentfilter(
                              $install_amavis = true,
                              $install_clamav = true,
                              $content_filter = 'smtp-amavis:[127.0.0.1]:10024'
                            ) inherits postfix::params {

  if($install_amavis)
  {
    class { 'amavis':
      install_clamav => $install_clamav,
    }
  }

  concat::fragment{ '/etc/postfix/main.cf content filter':
    target  => '/etc/postfix/main.cf',
    order   => '60',
    content => template("${module_name}/contentfilter.erb"),
  }
}