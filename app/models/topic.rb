class Topic < ActiveRecord::Base
  extend FriendlyId

  #paginates_per 15
  friendly_id :title, :use => :slugged

  has_many :codemark_topics
  has_many :codemarks, :through => :codemark_topics
  has_many :links, :through => :codemarks

  validates_presence_of :title

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }
  scope :for_user, lambda { |user| joins(:codemarks).where(["codemarks.user_id = ?",user]) }

  def self.private_topic_id
    Topic.where(:title => 'private').pluck(:id).first
  end
end

