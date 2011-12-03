class Topic < ActiveRecord::Base
  extend FriendlyId

  paginates_per 15
  friendly_id :title, :use => :slugged

  has_many :link_topics
  has_many :links, :through => :link_topics
  has_many :sponsored_sites, :inverse_of => :topic, :dependent => :destroy
  accepts_nested_attributes_for :sponsored_sites, :reject_if => lambda {|s| s[:url].blank? || s[:site].blank? }

  validates_presence_of :title
  validates_uniqueness_of :title

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }

  scope :mine, lambda { |user_id| 
                joins('INNER JOIN link_topics mylt on mylt.topic_id = topics.id')
                .joins('INNER JOIN link_saves on link_saves.link_id = mylt.link_id')
                .where(['link_saves.user_id = ?', user_id]) }

  scope :by_recent_activity, select('topics.*, link_topics.created_at')
                            .joins(:link_topics)
                            .order('link_topics.created_at DESC')

  scope :by_resource_count, select("topics.id, topics.title, topics.description, topics.slug, count(link_topics.id) as count")
                        .joins(:link_topics)
                        .group("topics.id, topics.title, topics.description, topics.slug")
                        .order("count DESC")

  def resource_count current_user, filter_by_mine
    if current_user.nil?
      self.links.all_public.count
    elsif filter_by_mine
      self.links.for_user(current_user).count
    else
      self.links.public_and_for_user(current_user).count
    end
  end


  def self.all_public
    Link.topics(Link.public)
  end

  def self.public_and_for_user(user)
    user.topics | Topic.all_public
  end

  def self.for_user(user)
    user.topics
  end

#  def self.by_recent_activity
   # self. LinkTopic.most_recent_by_topics
  #end

end

