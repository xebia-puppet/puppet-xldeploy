require 'spec_helper_acceptance'
require 'pry'

describe 'server:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do


  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
      class { 'xldeploy::server':
              install_java      =>  true,
              install_license   =>  true,
              version           => '4.5.0',
              download_user     => 'download',
              download_password => '3BcWgPuvtW3gCu'
            }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe port(4516) do
    it { should be_listening }
  end


end