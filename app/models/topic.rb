class Topic < ActiveRecord::Base

  has_and_belongs_to_many :codemarks
  has_many :resources, :through => :codemarks
  belongs_to :group

  validates_presence_of :title

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }

  before_save :set_slug
  after_create :clear_topic_cache

  def set_slug
    self.slug = self.title.parameterize if self.title
  end

  def to_param
    self.slug
  end

  def self.private_topic_id
    where(:title => 'private').pluck(:id).first
  end

  def self.for_user(user)
    if user.present?
      where('group_id IS NULL OR group_id IN (?)', user.group_ids)
    else
      where(:group_id => nil)
    end
  end

  def clear_topic_cache
    Rails.cache.delete('topics-json')
  end

  def self.search_for(topic)
    where('LOWER(?) = LOWER(title)', topic).first
  end
end

