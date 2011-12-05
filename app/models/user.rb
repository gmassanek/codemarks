class User < ActiveRecord::Base

  has_secure_password

  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'user_id'
  has_many :links, :through => :link_saves
  has_many :link_topics, :through => :links, :uniq => true
  has_many :topics, :through => :link_topics, :uniq => true
  has_many :reminders

  def public_and_my_topics
    Topic.join_links.join_link_saves.private_or_for_user(self).group_by_topic
  end

  validates_presence_of :email

  def has_reminder_for?(link)
    self.reminders.unfinished.for_link(link.id).present?
  end

end
