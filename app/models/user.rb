class User < ActiveRecord::Base

  has_secure_password

  validates_presence_of :email

  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'user_id'
  has_many :links, :through => :link_saves

  has_many :link_topics, :through => :links, :uniq => true
  has_many :topics, :through => :link_topics, :uniq => true

  has_many :clicks

  def has_saved_link? link
    links.include? link
  end

  def has_reminder_for?(link)
    self.reminders.unfinished.for_link(link.id).present?
  end

end
