class postfix::mastercf(
                          $add_default_smtpd_instance = true,
                          $default_smtpd_args         = undef,
                        )  inherits postfix::params {

  case $::osfamily
  {
    'redhat':
    {
      $setgid_group_default='postdrop'

      case $::operatingsystemrelease
      {
        /^5.*$/:
        {
          fail('unimplemented')
        }
        /^6.*$/:
        {
          # smtp      inet  n       -       n       -       -       smtpd
          if($add_default_smtpd_instance)
          {
            # service type  private unpriv  chroot  wakeup  maxproc command + args
            # smtp      inet  n       -       n       -       -       smtpd
            postfix::instance { 'smtp inet':
              service => 'smtp',
              type    => 'inet',
              private => 'n',
              chroot  => 'n',
              command => 'smtpd',
              args    => $default_smtpd_args,
              order   => '01',
            }
          }

          # pickup    fifo  n       -       n       60      1       pickup
          postfix::instance { 'pickup':
            type    => 'fifo',
            private => 'n',
            chroot  => 'n',
            wakeup  => '60',
            maxproc => '1',
            command => 'pickup',
            order   => '02',
          }

          # cleanup   unix  n       -       n       -       0       cleanup
          postfix::instance { 'cleanup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            maxproc => '0',
            command => 'cleanup',
            order   => '03',
          }


          # qmgr      fifo  n       -       n       300     1       qmgr
          postfix::instance { 'qmgr':
            type    => 'fifo',
            private => 'n',
            chroot  => 'n',
            wakeup  => '300',
            maxproc => '1',
            command => 'qmgr',
            order   => '04',
          }

          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          postfix::instance { 'tlsmgr':
            type    => 'unix',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '1',
            command => 'tlsmgr',
            order   => '05',
          }

          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          postfix::instance { 'rewrite':
            type    => 'unix',
            chroot  => 'n',
            command => 'trivial-rewrite',
            order   => '06',
          }

          # bounce    unix  -       -       n       -       0       bounce
          postfix::instance { 'bounce':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '07',
          }

          # defer     unix  -       -       n       -       0       bounce
          postfix::instance { 'defer':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '08',
          }

          # trace     unix  -       -       n       -       0       bounce
          postfix::instance { 'trace':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '09',
          }

          # verify    unix  -       -       n       -       1       verify
          postfix::instance { 'verify':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'verify',
            order   => '10',
          }

          # flush     unix  n       -       n       1000?   0       flush
          postfix::instance { 'flush':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '0',
            command => 'flush',
            order   => '11',
          }

          # proxymap  unix  -       -       n       -       -       proxymap
          postfix::instance { 'proxymap':
            type    => 'unix',
            chroot  => 'n',
            command => 'proxymap',
            order   => '12',
          }

          # proxywrite unix -       -       n       -       1       proxymap
          postfix::instance { 'proxywrite':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'proxymap',
            order   => '13',
          }

          # smtp      unix  -       -       n       -       -       smtp
          postfix::instance { 'smtp unix':
            service => 'smtp',
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '14',
          }

          # relay     unix  -       -       n       -       -       smtp
          #   -o smtp_fallback_relay=
          postfix::instance { 'relay':
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            opts    => { 'smtp_fallback_relay' => '' },
            order   => '15',
          }

          # showq     unix  n       -       n       -       -       showq
          postfix::instance { 'showq':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            command => 'showq',
            order   => '16',
          }

          # error     unix  -       -       n       -       -       error
          postfix::instance { 'error':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '17',
          }

          # retry     unix  -       -       n       -       -       error
          postfix::instance { 'retry':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '18',
          }

          # discard   unix  -       -       n       -       -       discard
          postfix::instance { 'discard':
            type    => 'unix',
            chroot  => 'n',
            command => 'discard',
            order   => '19',
          }

          # local     unix  -       n       n       -       -       local
          postfix::instance { 'local':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'local',
            order   => '20',
          }

          # virtual   unix  -       n       n       -       -       virtual
          postfix::instance { 'virtual':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'virtual',
            order   => '21',
          }

          # lmtp      unix  -       -       n       -       -       lmtp
          postfix::instance { 'lmtp':
            type    => 'unix',
            chroot  => 'n',
            command => 'lmtp',
            order   => '22',
          }

          # anvil     unix  -       -       n       -       1       anvil
          postfix::instance { 'anvil':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'anvil',
            order   => '23',
          }

          # scache    unix  -       -       n       -       1       scache
          postfix::instance { 'scache':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'scache',
            order   => '24',
          }
        }
        /^7.*$/:
        {
          # smtp      inet  n       -       n       -       -       smtpd
          if($add_default_smtpd_instance)
          {
            # service type  private unpriv  chroot  wakeup  maxproc command + args
            # smtp      inet  n       -       n       -       -       smtpd
            postfix::instance { 'smtp inet':
              service => 'smtp',
              type    => 'inet',
              private => 'n',
              chroot  => 'n',
              command => 'smtpd',
              args    => $default_smtpd_args,
              order   => '01',
            }
          }

          # pickup    unix  n       -       n       60      1       pickup
          postfix::instance { 'pickup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '60',
            maxproc => '1',
            command => 'pickup',
            order   => '02',
          }

          # cleanup   unix  n       -       n       -       0       cleanup
          postfix::instance { 'cleanup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            maxproc => '0',
            command => 'cleanup',
            order   => '03',
          }


          # qmgr      unix  n       -       n       300     1       qmgr
          postfix::instance { 'qmgr':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '300',
            maxproc => '1',
            command => 'qmgr',
            order   => '04',
          }

          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          postfix::instance { 'tlsmgr':
            type    => 'unix',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '1',
            command => 'tlsmgr',
            order   => '05',
          }

          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          postfix::instance { 'rewrite':
            type    => 'unix',
            chroot  => 'n',
            command => 'trivial-rewrite',
            order   => '06',
          }

          # bounce    unix  -       -       n       -       0       bounce
          postfix::instance { 'bounce':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '07',
          }

          # defer     unix  -       -       n       -       0       bounce
          postfix::instance { 'defer':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '08',
          }

          # trace     unix  -       -       n       -       0       bounce
          postfix::instance { 'trace':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '09',
          }

          # verify    unix  -       -       n       -       1       verify
          postfix::instance { 'verify':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'verify',
            order   => '10',
          }

          # flush     unix  n       -       n       1000?   0       flush
          postfix::instance { 'flush':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '0',
            command => 'flush',
            order   => '11',
          }

          # proxymap  unix  -       -       n       -       -       proxymap
          postfix::instance { 'proxymap':
            type    => 'unix',
            chroot  => 'n',
            command => 'proxymap',
            order   => '12',
          }

          # proxywrite unix -       -       n       -       1       proxymap
          postfix::instance { 'proxywrite':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'proxymap',
            order   => '13',
          }

          # smtp      unix  -       -       n       -       -       smtp
          postfix::instance { 'smtp unix':
            service => 'smtp',
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '14',
          }

          # relay     unix  -       -       n       -       -       smtp
          postfix::instance { 'relay':
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '15',
          }

          # showq     unix  n       -       n       -       -       showq
          postfix::instance { 'showq':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            command => 'showq',
            order   => '16',
          }

          # error     unix  -       -       n       -       -       error
          postfix::instance { 'error':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '17',
          }

          # retry     unix  -       -       n       -       -       error
          postfix::instance { 'retry':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '18',
          }

          # discard   unix  -       -       n       -       -       discard
          postfix::instance { 'discard':
            type    => 'unix',
            chroot  => 'n',
            command => 'discard',
            order   => '19',
          }

          # local     unix  -       n       n       -       -       local
          postfix::instance { 'local':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'local',
            order   => '20',
          }

          # virtual   unix  -       n       n       -       -       virtual
          postfix::instance { 'virtual':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'virtual',
            order   => '21',
          }

          # lmtp      unix  -       -       n       -       -       lmtp
          postfix::instance { 'lmtp':
            type    => 'unix',
            chroot  => 'n',
            command => 'lmtp',
            order   => '22',
          }

          # anvil     unix  -       -       n       -       1       anvil
          postfix::instance { 'anvil':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'anvil',
            order   => '23',
          }

          # scache    unix  -       -       n       -       1       scache
          postfix::instance { 'scache':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'scache',
            order   => '24',
          }
        }
        /^8.*$/:
        {
          # smtp      inet  n       -       n       -       -       smtpd
          # pickup    unix  n       -       n       60      1       pickup
          # cleanup   unix  n       -       n       -       0       cleanup
          # qmgr      unix  n       -       n       300     1       qmgr
          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          # bounce    unix  -       -       n       -       0       bounce
          # defer     unix  -       -       n       -       0       bounce
          # trace     unix  -       -       n       -       0       bounce
          # verify    unix  -       -       n       -       1       verify
          # flush     unix  n       -       n       1000?   0       flush
          # proxymap  unix  -       -       n       -       -       proxymap
          # proxywrite unix -       -       n       -       1       proxymap
          # smtp      unix  -       -       n       -       -       smtp
          # relay     unix  -       -       n       -       -       smtp
          #         -o syslog_name=postfix/$service_name
          # showq     unix  n       -       n       -       -       showq
          # error     unix  -       -       n       -       -       error
          # retry     unix  -       -       n       -       -       error
          # discard   unix  -       -       n       -       -       discard
          # local     unix  -       n       n       -       -       local
          # virtual   unix  -       n       n       -       -       virtual
          # lmtp      unix  -       -       n       -       -       lmtp
          # anvil     unix  -       -       n       -       1       anvil
          # scache    unix  -       -       n       -       1       scache

          # smtp      inet  n       -       n       -       -       smtpd
          if($add_default_smtpd_instance)
          {
            # service type  private unpriv  chroot  wakeup  maxproc command + args
            # smtp      inet  n       -       n       -       -       smtpd
            postfix::instance { 'smtp inet':
              service => 'smtp',
              type    => 'inet',
              private => 'n',
              chroot  => 'n',
              command => 'smtpd',
              order   => '01',
            }
          }

          # pickup    unix  n       -       n       60      1       pickup
          postfix::instance { 'pickup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '60',
            maxproc => '1',
            command => 'pickup',
            order   => '02',
          }

          # cleanup   unix  n       -       n       -       0       cleanup
          postfix::instance { 'cleanup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            maxproc => '0',
            command => 'cleanup',
            order   => '03',
          }


          # qmgr      unix  n       -       n       300     1       qmgr
          postfix::instance { 'qmgr':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '300',
            maxproc => '1',
            command => 'qmgr',
            order   => '04',
          }

          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          postfix::instance { 'tlsmgr':
            type    => 'unix',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '1',
            command => 'tlsmgr',
            order   => '05',
          }

          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          postfix::instance { 'rewrite':
            type    => 'unix',
            chroot  => 'n',
            command => 'trivial-rewrite',
            order   => '06',
          }

          # bounce    unix  -       -       n       -       0       bounce
          postfix::instance { 'bounce':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '07',
          }

          # defer     unix  -       -       n       -       0       bounce
          postfix::instance { 'defer':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '08',
          }

          # trace     unix  -       -       n       -       0       bounce
          postfix::instance { 'trace':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '09',
          }

          # verify    unix  -       -       n       -       1       verify
          postfix::instance { 'verify':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'verify',
            order   => '10',
          }

          # flush     unix  n       -       n       1000?   0       flush
          postfix::instance { 'flush':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '0',
            command => 'flush',
            order   => '11',
          }

          # proxymap  unix  -       -       n       -       -       proxymap
          postfix::instance { 'proxymap':
            type    => 'unix',
            chroot  => 'n',
            command => 'proxymap',
            order   => '12',
          }

          # proxywrite unix -       -       n       -       1       proxymap
          postfix::instance { 'proxywrite':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'proxymap',
            order   => '13',
          }

          # smtp      unix  -       -       n       -       -       smtp
          postfix::instance { 'smtp unix':
            service => 'smtp',
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '14',
          }

          # relay     unix  -       -       n       -       -       smtp
          postfix::instance { 'relay':
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '15',
            opts    => { 'syslog_name' => 'postfix/$service_name' },
          }

          # showq     unix  n       -       n       -       -       showq
          postfix::instance { 'showq':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            command => 'showq',
            order   => '16',
          }

          # error     unix  -       -       n       -       -       error
          postfix::instance { 'error':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '17',
          }

          # retry     unix  -       -       n       -       -       error
          postfix::instance { 'retry':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '18',
          }

          # discard   unix  -       -       n       -       -       discard
          postfix::instance { 'discard':
            type    => 'unix',
            chroot  => 'n',
            command => 'discard',
            order   => '19',
          }

          # local     unix  -       n       n       -       -       local
          postfix::instance { 'local':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'local',
            order   => '20',
          }

          # virtual   unix  -       n       n       -       -       virtual
          postfix::instance { 'virtual':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'virtual',
            order   => '21',
          }

          # lmtp      unix  -       -       n       -       -       lmtp
          postfix::instance { 'lmtp':
            type    => 'unix',
            chroot  => 'n',
            command => 'lmtp',
            order   => '22',
          }

          # anvil     unix  -       -       n       -       1       anvil
          postfix::instance { 'anvil':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'anvil',
            order   => '23',
          }

          # scache    unix  -       -       n       -       1       scache
          postfix::instance { 'scache':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'scache',
            order   => '24',
          }
        }
        /^9.*$/:
        {
          # smtp      inet  n       -       n       -       -       smtpd
          # pickup    unix  n       -       n       60      1       pickup
          # cleanup   unix  n       -       n       -       0       cleanup
          # qmgr      unix  n       -       n       300     1       qmgr
          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          # bounce    unix  -       -       n       -       0       bounce
          # defer     unix  -       -       n       -       0       bounce
          # trace     unix  -       -       n       -       0       bounce
          # verify    unix  -       -       n       -       1       verify
          # flush     unix  n       -       n       1000?   0       flush
          # proxymap  unix  -       -       n       -       -       proxymap
          # proxywrite unix -       -       n       -       1       proxymap
          # smtp      unix  -       -       n       -       -       smtp
          # relay     unix  -       -       n       -       -       smtp
          #         -o syslog_name=postfix/$service_name
          # showq     unix  n       -       n       -       -       showq
          # error     unix  -       -       n       -       -       error
          # retry     unix  -       -       n       -       -       error
          # discard   unix  -       -       n       -       -       discard
          # local     unix  -       n       n       -       -       local
          # virtual   unix  -       n       n       -       -       virtual
          # lmtp      unix  -       -       n       -       -       lmtp
          # anvil     unix  -       -       n       -       1       anvil
          # scache    unix  -       -       n       -       1       scache

          # smtp      inet  n       -       n       -       -       smtpd
          if($add_default_smtpd_instance)
          {
            # service type  private unpriv  chroot  wakeup  maxproc command + args
            # smtp      inet  n       -       n       -       -       smtpd
            postfix::instance { 'smtp inet':
              service => 'smtp',
              type    => 'inet',
              private => 'n',
              chroot  => 'n',
              command => 'smtpd',
              order   => '01',
            }
          }

          # pickup    unix  n       -       n       60      1       pickup
          postfix::instance { 'pickup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '60',
            maxproc => '1',
            command => 'pickup',
            order   => '02',
          }

          # cleanup   unix  n       -       n       -       0       cleanup
          postfix::instance { 'cleanup':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            maxproc => '0',
            command => 'cleanup',
            order   => '03',
          }


          # qmgr      unix  n       -       n       300     1       qmgr
          postfix::instance { 'qmgr':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '300',
            maxproc => '1',
            command => 'qmgr',
            order   => '04',
          }

          # tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          postfix::instance { 'tlsmgr':
            type    => 'unix',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '1',
            command => 'tlsmgr',
            order   => '05',
          }

          # rewrite   unix  -       -       n       -       -       trivial-rewrite
          postfix::instance { 'rewrite':
            type    => 'unix',
            chroot  => 'n',
            command => 'trivial-rewrite',
            order   => '06',
          }

          # bounce    unix  -       -       n       -       0       bounce
          postfix::instance { 'bounce':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '07',
          }

          # defer     unix  -       -       n       -       0       bounce
          postfix::instance { 'defer':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '08',
          }

          # trace     unix  -       -       n       -       0       bounce
          postfix::instance { 'trace':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '0',
            command => 'bounce',
            order   => '09',
          }

          # verify    unix  -       -       n       -       1       verify
          postfix::instance { 'verify':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'verify',
            order   => '10',
          }

          # flush     unix  n       -       n       1000?   0       flush
          postfix::instance { 'flush':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            wakeup  => '1000?',
            maxproc => '0',
            command => 'flush',
            order   => '11',
          }

          # proxymap  unix  -       -       n       -       -       proxymap
          postfix::instance { 'proxymap':
            type    => 'unix',
            chroot  => 'n',
            command => 'proxymap',
            order   => '12',
          }

          # proxywrite unix -       -       n       -       1       proxymap
          postfix::instance { 'proxywrite':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'proxymap',
            order   => '13',
          }

          # smtp      unix  -       -       n       -       -       smtp
          postfix::instance { 'smtp unix':
            service => 'smtp',
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '14',
          }

          # relay     unix  -       -       n       -       -       smtp
          postfix::instance { 'relay':
            type    => 'unix',
            chroot  => 'n',
            command => 'smtp',
            order   => '15',
            opts    => { 'syslog_name' => 'postfix/$service_name' },
          }

          # showq     unix  n       -       n       -       -       showq
          postfix::instance { 'showq':
            type    => 'unix',
            private => 'n',
            chroot  => 'n',
            command => 'showq',
            order   => '16',
          }

          # error     unix  -       -       n       -       -       error
          postfix::instance { 'error':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '17',
          }

          # retry     unix  -       -       n       -       -       error
          postfix::instance { 'retry':
            type    => 'unix',
            chroot  => 'n',
            command => 'error',
            order   => '18',
          }

          # discard   unix  -       -       n       -       -       discard
          postfix::instance { 'discard':
            type    => 'unix',
            chroot  => 'n',
            command => 'discard',
            order   => '19',
          }

          # local     unix  -       n       n       -       -       local
          postfix::instance { 'local':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'local',
            order   => '20',
          }

          # virtual   unix  -       n       n       -       -       virtual
          postfix::instance { 'virtual':
            type    => 'unix',
            unpriv  => 'n',
            chroot  => 'n',
            command => 'virtual',
            order   => '21',
          }

          # lmtp      unix  -       -       n       -       -       lmtp
          postfix::instance { 'lmtp':
            type    => 'unix',
            chroot  => 'n',
            command => 'lmtp',
            order   => '22',
          }

          # anvil     unix  -       -       n       -       1       anvil
          postfix::instance { 'anvil':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'anvil',
            order   => '23',
          }

          # scache    unix  -       -       n       -       1       scache
          postfix::instance { 'scache':
            type    => 'unix',
            chroot  => 'n',
            maxproc => '1',
            command => 'scache',
            order   => '24',
          }
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
          $setgid_group_default='postdrop'

          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              fail('unimplemented')
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

      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {

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
