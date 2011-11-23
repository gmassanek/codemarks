class User < ActiveRecord::Base

  has_secure_password

  has_many :links
  has_many :reminders

  validates_presence_of :email

  def has_reminder_for?(link)
    self.reminders.unfinished.for_link(link.id).present?
  end

end
