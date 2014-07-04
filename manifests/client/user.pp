# == Class: xldeploy::client::user
#
# This class takes care of the configuration of xldeploy external nodes
# === Examples
#
#
#
# === Parameters
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::client::user(
  $os_user                   = $xldeploy::os_user,
  $os_group                  = $xldeploy::os_group,
  $http_server_address       = $xldeploy::http_server_address,
  $client_sudo               = $xldeploy::client_sudo,
  $client_user_password      = $xldeploy::client_user_password,
  $client_user_password_salt = $xldeploy::client_user_password_salt,
  $import_ssh_key            = $xldeploy::import_ssh_key){

  # Resources

  #user and group

  group{$os_group:
    ensure => 'present'
  }

  user{$os_user:
    ensure      => present,
    gid         => $os_group ,
    managehome  => true,
    password    => md5pass($client_user_password,$client_user_password_salt)
  }

  if str2bool($client_sudo) {

    file {'/etc/sudoers.d':
      ensure => directory }

    file {'/etc/sudoers.d/50_xldeploy':
      ensure  => present,
      content => template('xldeploy/xldeploy_sudoers.erb')
    }


  }

  sshkeys::set_authorized_key { "${os_user}@${http_server_address}":
    local_user  => $os_user,
    remote_user => "${os_user}@${http_server_address}",
    home        => "/home/${os_user}",
  }


}