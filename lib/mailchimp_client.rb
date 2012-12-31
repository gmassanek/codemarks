class MailchimpClient
  def self.subscribed?(email)
    return unless email.present?
    response = mailchimp.list_member_info({
      :id => weekly_digest_list_id,
      :email_address => [email]
    })
    response['data'].first['status'] == 'subscribed'
  end

  def self.subscribe(email)
    mailchimp.list_subscribe({
      :id => weekly_digest_list_id,
      :email_address => email
    })
  end

  def self.unsubscribe(email)
    mailchimp.list_unsubscribe({
      :id => weekly_digest_list_id,
      :email_address => email
    })
  end

  def self.mailchimp
    Gibbon.new
  end

  def self.weekly_digest_list_id
    'fe2d7ff8fb'
  end
end
