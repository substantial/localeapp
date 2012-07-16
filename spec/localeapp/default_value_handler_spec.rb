require 'spec_helper'

class Klass
  include I18n::Backend::Base
end

class I18nWithFallbacks < I18n::Backend::Simple
  include I18n::Backend::Fallbacks
end

describe I18n::Backend::Base, '#default' do
  let(:klass) { Klass.new }

  it "posts translations to Locale" do
    with_configuration(:sending_environments => ['my_env'], :environment_name => 'my_env' ) do
      sender = Localeapp::Sender.new
      Localeapp::Sender.should_receive(:new).and_return(sender)
      sender.should_receive(:post_translation)
      klass.default('locale', 'object', 'subject')
    end
  end

  it "doesn't post when sending is disabled" do
    with_configuration(:sending_environments => []) do
      Localeapp::Sender.should_not_receive(:new)
      klass.default('locale', 'object', 'subject')
    end
  end

  it "works with fallbacks" do
    i18n = I18nWithFallbacks.new

    sender = stub
    Localeapp::Sender.stub(:new) { sender }

    sender.should_receive(:post_translation).with('en', 'object', {:default => 'subject'}, 'subject')

    with_configuration(:sending_environments => ['my_env'], :environment_name => 'my_env' ) do
      i18n.translate('en', 'object', :default => 'subject')
    end
  end
end
