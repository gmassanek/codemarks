class Link < ActiveRecord::Base

  has_many :link_topics, :inverse_of => :link
  has_many :topics, :through => :link_topics
  has_many :clicks
  has_many :reminders
  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'link_id'
  belongs_to :user

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  validates_uniqueness_of :url

  before_validation :fetch_title 

  scope :by_click_count, select('links.*')
                      .joins('LEFT JOIN clicks ON clicks.link_id = links.id')
                      .group('links.id')
                      .order('count(clicks.id) DESC')

  scope :by_save_count, select("links.*")
                          .joins("LEFT JOIN link_saves ON link_saves.link_id = links.id")
                          .group("link_saves.link_id")
                          .order("count(link_saves.id) DESC")


  def save_count
    link_saves.count
  end

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
    topics = @http_connection.topics
    return topics
  end
  
end
