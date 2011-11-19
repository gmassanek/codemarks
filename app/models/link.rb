class Link < ActiveRecord::Base

  has_many :link_topics, :inverse_of => :link
  has_many :topics, :through => :link_topics
  belongs_to :user
  has_many :clicks
  has_many :reminders

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  validates_uniqueness_of :url

  before_validation :fetch_title 

  scope :by_saves, order('save_count desc')
  scope :clicks, select('links.id, COUNT(*) AS click_count') 
                      .joins('LEFT JOIN clicks ON clicks.link_id = links.id')
                      .group('links.id')
                      .order('click_count DESC')

  def self.by_clicks
    self.clicks.collect { |result| self.find result.id }
  end

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
