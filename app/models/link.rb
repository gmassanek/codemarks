class Link < ActiveRecord::Base

  has_many :link_topics, :inverse_of => :link
  accepts_nested_attributes_for :link_topics
  has_many :topics, :through => :link_topics

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp

end
