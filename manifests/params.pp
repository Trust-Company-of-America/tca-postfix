#
class postfix::params {

  $package_name='postfix'
  $baseconf = '/etc/postfix'

  # $package_postfix_utils = 'postfix-perl-scripts'

  case $::osfamily
  {
    'redhat':
    {
      $setgid_group_default='postdrop'
      $compatibility_level_default=undef

      $daemon_directory_default='/usr/libexec/postfix'
      #$dependencies=['chkconfig', 'grep']
      $switch_to_postfix='alternatives --set mta /usr/sbin/sendmail.postfix'
      $check_postfix_mta='alternatives --display mta | grep postfix'

      $purge_default_mta=[ 'exim', 'sendmail' ]

      $readme_directory_default = false

      $postfix_username_uid_default='89'
      $postfix_username_gid_default='89'

      case $::operatingsystemrelease
      {
        /^5.*$/:
        {
          $manage_mastercf_default=false
          $postfix_ver='2.3.3'
          $mailclient=[ 'mailx' ]
        }
        /^6.*$/:
        {
          $manage_mastercf_default=true
          $postfix_ver='2.6.6'
          $mailclient=[ 'mailx' ]
        }
        /^7.*$/:
        {
          $manage_mastercf_default=true
          $postfix_ver='2.10.1'
          $mailclient=[ 'mailx' ]
        }
        /^8.*$/:
        {
          $manage_mastercf_default=true
          $postfix_ver='3.3.1'
          $mailclient=[ 'mailx' ]
        }
        /^9.*$/:
        {
          $manage_mastercf_default=true
          $postfix_ver='3.3.1'
          $mailclient=[ 's-nail' ]
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          $manage_mastercf_default=false
          $setgid_group_default='postdrop'

          $switch_to_postfix=undef
          $check_postfix_mta=undef

          $purge_default_mta=undef

          $mailclient=[ 'mailutils' ]

          $readme_directory_default='/usr/share/doc/postfix'

          if($::facts!=undef)
          {
            if has_key($::facts, 'eyp_postfix_uid')
            {
              # $postfix_username_uid_default=hiera('::eyp_postfix_uid', '89'),
              $postfix_username_uid_default = $::facts['eyp_postfix_uid'] ? {
                undef   => '89',
                default => $::facts['eyp_postfix_uid'],
              }
            }
            else
            {
              $postfix_username_uid_default = '89'
            }

            if has_key($::facts, 'eyp_postfix_gid')
            {
              # $postfix_username_gid_default=hiera('::eyp_postfix_gid', '89'),
              $postfix_username_gid_default = $::facts['eyp_postfix_gid'] ? {
                undef   => '89',
                default => $::facts['eyp_postfix_gid'],
              }
            }
            else
            {
              $postfix_username_gid_default = '89'
            }
          }
          else
          {
            $postfix_username_uid_default = $::eyp_postfix_uid ? {
              undef   => '89',
              default => $::eyp_postfix_uid,
            }
            $postfix_username_gid_default = $::eyp_postfix_gid ? {
              undef   => '89',
              default => $::eyp_postfix_gid,
            }
          }

          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $daemon_directory_default='/usr/lib/postfix'
              $postfix_ver='2.11.0'
              $compatibility_level_default=undef
            }
            /^16.*$/:
            {
              $daemon_directory_default='/usr/lib/postfix/sbin'
              $postfix_ver='3.1.0'
              $compatibility_level_default=undef
            }
            /^18.*$/:
            {
              $daemon_directory_default='/usr/lib/postfix/sbin'
              $postfix_ver='3.3.0'
              $compatibility_level_default=2
            }
            /^20.*$/:
            {
              $daemon_directory_default='/usr/lib/postfix/sbin'
              $postfix_ver='3.4.10'
              $compatibility_level_default=2
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse':
    {
      $setgid_group_default='maildrop'
      $compatibility_level_default=undef

      $manage_mastercf_default=false
      $daemon_directory_default='/usr/lib/postfix'
      #$dependencies=['dpkg', 'grep' ]
      $switch_to_postfix=undef
      $check_postfix_mta=undef

      $purge_default_mta=[ 'sendmail' ]

      $mailclient=[ 'mailx' ]

      $readme_directory_default=false

      $postfix_username_uid_default='51'
      $postfix_username_gid_default='51'

      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {
              $postfix_ver='2.9.4'
            }
            /^12.[34]/:
            {
              $postfix_ver='3.2.0'
            }
            default: { fail("Unsupported operating system ${::operatingsystem} ${::operatingsystemrelease}") }
          }
        }
        default: { fail("Unsupported operating system ${::operatingsystem}") }
      }
    }
    default: { fail('Unsupported OS!')  }
  }

}
