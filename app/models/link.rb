class Link < ActiveRecord::Base

  has_many :link_topics, :inverse_of => :link
  has_many :topics, :through => :link_topics
  belongs_to :user

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  validates_uniqueness_of :url

  before_validation :fetch_title 


  def fetch_title
    if !url.blank? && title.blank?
      @http_connection = SmartLinks::MyCurl.new url
      self.title = @http_connection.title
    end
  end

  def possible_topics
    @http_connection = SmartLinks::MyCurl.new(url) 
    @http_connection.topics
  end
  
end
