class Topic < ActiveRecord::Base
  extend FriendlyId

  #paginates_per 15
  friendly_id :title, :use => :slugged

  has_many :codemark_topics
  has_many :codemarks, :through => :codemark_topics
  has_many :resources, :through => :codemarks
  belongs_to :group

  validates_presence_of :title

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }

  after_create :clear_topic_cache

  def self.private_topic_id
    where(:title => 'private').pluck(:id).first
  end

  def self.for_user(user)
    where('group_id IS NULL OR group_id IN (?)', user.try(:group_ids))
  end

  def clear_topic_cache
    Rails.cache.delete('topics-json')
  end
end

