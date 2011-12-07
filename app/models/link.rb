class Link < ActiveRecord::Base
  paginates_per 15

  has_many :link_topics, :inverse_of => :link
  has_many :topics, :through => :link_topics
  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'link_id', :dependent => :destroy
  has_many :users, :through => :link_saves
  has_many :clicks
  has_many :reminders
  belongs_to :user

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  validates_uniqueness_of :url

  before_validation :fetch_title 

  scope :all_public, where(['private = ?', false])
  scope :private, where(['private = ?', true])
  scope :public_and_for_user, lambda { |user| 
    joins(:link_saves)
    .where(['link_saves.user_id = ? OR private = ?', user, false]) 
  }

  scope :for_user, lambda { |user| 
    joins(:link_saves)
    .where(['link_saves.user_id = ?', user]) 
  }
  scope :for_topic, lambda { |topic| joins(:link_topics).where(["link_topics.topic_id = ?", topic]) }
  scope :topics, joins(:link_topics).joins(:topics).select("topics.*")

  scope :by_popularity, order('popularity DESC')
  scope :by_create_date, order('created_at DESC')
  
  def self.topics(links)
    link_topics = LinkTopic.for_links(links)
    Topic.for_link_topics(link_topics)
  end

  def save_count
    link_saves.count
  end

  def self.by_clicks
    self.clicks.collect { |result| self.find result.id }
  end

  def fetch_title
    if !url.blank? && title.blank?
      http_connection = SmartLinks::MyCurl.new url
      if http_connection.response.present?
        self.title = http_connection.title
      else
        errors.add(:url, "could not be fetched.  Make sure to add a title and some topics")
        return false
      end
    end
  end

  def possible_topics
    @http_connection = SmartLinks::MyCurl.new(url) 
    topics = @http_connection.topics
    return topics
  end

  def update_priority
    self.popularity = clicks.count + link_saves.count
    self.save
  end

  def most_popular_topics(n)
    topics.by_popularity.limit(n)
  end

end
