# == Define: quartermaster::matchbox
# Adds CoreOS Matchbox as part of the CoreOS deployment infrastructure
#
class quartermaster::matchbox (){

  validate_bool( $quartermaster::matchbox_enable )
  validate_string( $quartermaster::matchbox_version )

  if $quartermaster::matchbox_enable == true {
    user { 'matchbox':
      ensure     => 'present',
      managehome => true,
    } ->
    file{[
      '/var/lib/matchbox',
      '/var/lib/matchbox/assets',
      '/etc/matchbox',
    ]:
      ensure => directory,
      owner  => 'matchbox',
      group  => 'matchbox',

    }  -> 
    staging::deploy{"matchbox-v${quartermaster::matchbox_version}-linux-amd64.tar.gz":
      source => "https://github.com/coreos/matchbox/releases/download/v${quartermaster::matchbox_version}/matchbox-v${quartermaster::matchbox_version}-linux-amd64.tar.gz",
      target => '/home/matchbox',
    }

  }

}
