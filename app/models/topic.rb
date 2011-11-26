class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :link_topics
  has_many :links, :through => :link_topics
  has_many :sponsored_sites, :inverse_of => :topic, :dependent => :destroy
  accepts_nested_attributes_for :sponsored_sites, :reject_if => lambda {|s| s[:url].blank? || s[:site].blank? }

  scope :ids_by_resource_count, select('topics.id, COUNT(link_topics.link_id) AS link_count') 
                      .joins('LEFT JOIN link_topics ON link_topics.topic_id = topics.id')
                      .group('topics.id')
                      .order('link_count DESC')


  scope :by_recent_activity, select('distinct topics.*')
                            .joins('LEFT JOIN link_topics ON link_topics.topic_id = topics.id')
                            .order('link_topics.created_at DESC')
  scope :mine

end

