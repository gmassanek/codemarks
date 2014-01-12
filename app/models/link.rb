require 'nokogiri'
require 'open-uri'
require 'postrank-uri'

class Link < ActiveRecord::Base
  TAG_SUGGESTION_LIMIT = 3

  has_many :topics, :through => :codemarks
  has_many :codemarks, :as => :resource
  has_many :clicks, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  before_validation :default_title
  after_create :trigger_snapshot
  validates_presence_of :url, :host

  def self.for_url(url)
    url = PostRank::URI.clean(url)
    find_by_url(url) || create_link_from_internet(url)
  end

  def self.create_link_from_internet(url)
    link = new
    link.url = url
    link.host = URI.parse(url).host

    html_response = Nokogiri::HTML(open(url))
    link.title = html_response.title.try(:strip)
    link.site_data = html_response.content
    link.save!
    link
  rescue OpenURI::HTTPError => e
    p e
    link.save!
    link
  rescue ActiveRecord::StatementInvalid => e
    p e
    link.site_data = nil
    link.save!
    link
  rescue RuntimeError
    p e
    link.site_data = nil
    link.save!
    link
  end

  def orphan?
    author_id.blank?
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end

  def default_title
    self.title ||= '(No title)'
  end

  def trigger_snapshot
    return unless url && id
    Delayed::Job.enqueue(SnapLinkJob.new(self))
  end

  def suggested_topics
    topics = Tagger.tag(self.title)
    return topics.first(TAG_SUGGESTION_LIMIT) if topics.length >= TAG_SUGGESTION_LIMIT

    topics += Tagger.tag(self.site_data)
    topics.uniq.first(TAG_SUGGESTION_LIMIT)
  end
end
