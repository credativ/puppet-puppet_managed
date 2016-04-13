require 'spec_helper'
describe 'puppet_managed' do

  context 'with defaults for all parameters' do
    it { should contain_class('puppet_managed') }
  end
end
