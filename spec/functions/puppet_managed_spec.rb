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
 context 'with comment_style => xml' do
    it {
      is_expected.to run.with_params({ 'comment_style' => 'xml'})
        .and_return ("<!--\n MANAGED BY PUPPET\n-->\n")
    }
  end
  context 'with comment_style => sql' do
    it {
      is_expected.to run.with_params({ 'comment_style' => 'sql'})
        .and_return("-- MANAGED BY PUPPET\n")
    }
  end

  context 'with comment_style => vim' do
    it {
      is_expected.to run.with_params({ 'comment_style' => 'vim'})
        .and_return("\" MANAGED BY PUPPET\n")
    }
  end

  context 'with custom prefix (!!)' do
    it {
      is_expected.to run.with_params({ 'prefix' => '!!'})
        .and_return("!! MANAGED BY PUPPET\n")
    }
  end

  context 'with verbose but no filename' do
    it {
      is_expected.to run.with_params({ 'verbose' => true })
        .and_raise_error(ArgumentError)
    }
  end
end
