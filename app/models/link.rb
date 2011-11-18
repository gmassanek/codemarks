class Link < ActiveRecord::Base

  has_many :link_topics, :inverse_of => :link
  has_many :topics, :through => :link_topics

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  validates_uniqueness_of :url

  before_validation :fetch_title 

  def fetch_title
    if !url.blank? && title.blank?
      self.title = SmartLinks::MyCurl.get_title_content(url)
    end
  end

  def possible_topics
    SmartLinks::MyCurl.get_possible_topics(url) 
  end
  
end
