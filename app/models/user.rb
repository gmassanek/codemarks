class User < ActiveRecord::Base

  has_secure_password

  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'user_id'
  has_many :links, :through => :link_saves
  has_many :link_topics, :through => :links, :uniq => true
  has_many :topics, :through => :link_topics, :uniq => true

  has_many :reminders

  #scope :my_topics, .joins("link_topics on link_topics.link_id = links.id")
  #                  .select("topics.*")

  validates_presence_of :email

  def has_reminder_for?(link)
    self.reminders.unfinished.for_link(link.id).present?
  end

  def my_topics
    links.topics
  end

end
