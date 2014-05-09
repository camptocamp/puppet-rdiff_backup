require 'spec_helper'

describe 'rdiff_backup::server' do
  let(:facts) {{
    :concat_basedir => '/foo',
    :osfamily       => 'Debian',
  }}
  it { should compile.with_all_deps }
end
