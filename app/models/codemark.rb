class Codemark < ActiveRecord::Base
  belongs_to :link, :counter_cache => true
  belongs_to :user

  has_many :codemark_topics
  has_many :topics, :through => :codemark_topics

  validates_presence_of :link
  validates_presence_of :user

  scope :unarchived, where(['archived = ?', false])
  scope :by_save_date, order('created_at DESC')
  scope :by_popularity, joins(:link).order('clicks_count DESC')
  scope :for, lambda { |links| includes(:link).where(['link_id in (?)', links]) }

  delegate :title, :url, :to => :link
end
