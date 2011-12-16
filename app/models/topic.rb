class Topic < ActiveRecord::Base
  extend FriendlyId

  #paginates_per 15
  friendly_id :title, :use => :slugged

  has_many :codemark_topics
  has_many :codemarks, :through => :codemark_topics
  belongs_to :user

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :user_id

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }
end

