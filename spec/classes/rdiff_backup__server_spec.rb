require 'spec_helper'

describe 'rdiff_backup::server' do
  let(:facts) {{
    :concat_basedir  => '/foo',
    :id              => 'root',
    :kernel          => 'Linux',
    :operatingsystem => 'Debian',
    :osfamily        => 'Debian',
    :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }}
  it { should compile.with_all_deps }
end
