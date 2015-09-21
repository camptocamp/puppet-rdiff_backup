require 'spec_helper'

describe 'rdiff_backup::server::install' do

  let(:title) {'1.2.8'}

  let(:pre_condition) do
    "class { '::rdiff_backup::server': }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/foo',
        })
      end

      it { is_expected.to compile.with_all_deps }

    end
  end
end
