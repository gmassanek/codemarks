class LinkSave < ActiveRecord::Base

  belongs_to :link, :counter_cache => true
  belongs_to :user

  has_many :codemark_topics, :foreign_key => :codemark_id
  has_many :topics, :through => :codemark_topics

  validates_presence_of :link
  validates_presence_of :user

  scope :unarchived, where(['archived = ?', false])
  scope :by_save_date, order('created_at DESC')
  scope :by_popularity, joins(:link)
                        .order('clicks_count DESC')

  #scope :by_link, joins(:link).select('DISTINCT(link_id), link_saves.*')
                        #
  #scope :by_link, joins(:link).group(:link_id)

  delegate :title, :url, :to => :link


end
