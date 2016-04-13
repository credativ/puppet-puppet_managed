require 'spec_helper'

describe 'puppet_managed' do
  context 'with default parameters' do
    it {
      is_expected.to run.with_params()
        .and_return ("# MANAGED BY PUPPET\n")
    }
  end
  context 'with comment_style => c-block' do
    it {
      is_expected.to run.with_params({ 'comment_style' => 'c-block'})
        .and_return ("/*\n  * MANAGED BY PUPPET\n  */\n")
    }
  end
end
