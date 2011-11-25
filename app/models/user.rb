class User < ActiveRecord::Base

  has_secure_password

  has_many :links, :through => :link_saves
  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'user_id'
  has_many :reminders

  validates_presence_of :email

  def has_reminder_for?(link)
    self.reminders.unfinished.for_link(link.id).present?
  end

end
