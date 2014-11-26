require 'spec_helper'

describe 'xldeploy::server::install' do


  shared_examples '3.9.x on a Linux Os' do
    let :default_params do
      {
          :version                     => '3.9.4',
          :tmp_dir                     => '/var/tmp',
          :base_dir                    => '/opt/deployit',
          :os_user                     => 'deployit',
          :os_group                    => 'deployit',
          :install_type                => 'download',
          :download_user               => 'download',
          :download_password           => 'download',
          :server_home_dir             => '/opt/deployit/deployit-server',
          :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
          :puppetfiles_xldeploy_source => 'modules/deployit/sources',
          :productname                 => 'deployit',
          :server_plugins              => { }
      }
    end

    context 'with install_type set to puppetfiles' do
      let :params do
          default_params.merge({
                                   :install_type                => 'puppetfiles'
                               })
      end

      it {should contain_file('/var/tmp/deployit-3.9.4-server.zip').with_source('modules/deployit/sources/deployit-3.9.4-server.zip')}
      it {should contain_file('/opt/deployit/deployit-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip /var/tmp/deployit-3.9.4-server.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-server/* /opt/deployit/deployit-3.9.4-server',
                      :creates => '/opt/deployit/deployit-3.9.4-server/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

  end

  shared_examples '4.x.x on a Linux Os' do
    let :default_params do
      {
          :version                     => '4.5.0',
          :tmp_dir                     => '/var/tmp',
          :base_dir                    => '/opt/xldeploy',
          :os_user                     => 'deployit',
          :os_group                    => 'deployit',
          :install_type                => 'download',
          :download_user               => 'download',
          :download_password           => 'download',
          :server_home_dir             => '/opt/xldeploy/xldeploy-server',
          :download_server_url         => 'https://tech.xebialabs.com/download/xl-deploy/4.5.0/xl-deploy-4.5.0-server.zip',
          :puppetfiles_xldeploy_source => 'modules/xldeploy/sources',
          :productname                 => 'xldeploy',
          :server_plugins              => { }
      }
    end

    context 'with install_type set to puppetfiles' do
      let :params do
          default_params.merge({
                                   :install_type                => 'puppetfiles'
                               })
      end

      it {should contain_file('/var/tmp/xldeploy-4.5.0-server.zip').with_source('modules/xldeploy/sources/xldeploy-4.5.0-server.zip')}
      it {should contain_file('/opt/xldeploy/xldeploy-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip /var/tmp/xldeploy-4.5.0-server.zip;/bin/cp -rp /var/tmp/xldeploy-4.5.0-server/* /opt/xldeploy/xldeploy-4.5.0-server',
                      :creates => '/opt/xldeploy/xldeploy-4.5.0-server/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end


    context 'with install_license set to true and puppet file given' do
      let :params do
        default_params.merge({
                                 :install_license             => 'true',
                                 :license_source              => 'modules/xldeploy/file/deployit-license.lic',
                             })
      end
      it {should contain_file('/opt/xldeploy/xldeploy-server/conf/deployit-license.lic').with_source('modules/xldeploy/file/deployit-license.lic')}
    end

    context 'with install_license set to true and url given' do
      let :params do
        default_params.merge({
                                 :install_license             => 'true',
                                 :license_source              => 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic',
                             })
      end

      it {should contain_xldeploy_license_install('https://tech.xebialabs.com/download/licenses/download/deployit-license.lic').with_destinationdirectory('/opt/xldeploy/xldeploy-server/conf')}
    end
  end
  
  
  context "Debian OS" do
    let :facts do
      {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
          :lsbdistcodename => 'precise',
          :lsbdistid       => 'Debian',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "3.9.x on a Linux Os" do

    end
    it_behaves_like "4.x.x on a Linux Os" do

    end

  end

  context "RedHat OS with xldeploy 3.9.x" do
    let :facts do
      {
          :operatingsystem => 'RedHat',
          :osfamily        => 'RedHat',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "3.9.x on a Linux Os" do

    end
    it_behaves_like "4.x.x on a Linux Os" do

    end
  end


end


