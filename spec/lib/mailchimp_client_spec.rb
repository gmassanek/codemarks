require 'spec_helper'

describe MailchimpClient do
  describe '#subscribed?' do
    it 'is false if there is no email' do
      MailchimpClient.subscribed?(nil).should be_false
    end

    it 'is false if there is a blank email' do
      MailchimpClient.subscribed?('').should be_false
    end

    it 'is true if Mailchimp says the user is subscribed' do
      VCR.use_cassette(:mailchimp_success) do
        MailchimpClient.subscribed?('gmassanek@gmail.com').should be_true
      end
    end

    it 'is false if Mailchimp says the user is not subscribed' do
      VCR.use_cassette(:mailchimp_failure) do
        MailchimpClient.subscribed?('somebody@nobody.com').should be_false
      end
    end
  end
end
