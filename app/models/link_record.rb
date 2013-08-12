require 'nokogiri'
require 'open-uri'
require 'postrank-uri'

class LinkRecord < ActiveRecord::Base
  TAG_SUGGESTION_LIMIT = 3

  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :as => :resource
  has_many :clicks, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  before_validation :default_title
  after_create :trigger_snapshot
  validates_presence_of :url, :host

  def self.for_url(url)
    url = PostRank::URI.clean(url)
    find_by_url(url) || create_link_record_from_internet(url)
  end

  def self.create_link_record_from_internet(url)
    link_record = new
    link_record.url = url
    link_record.host = URI.parse(url).host

    html_response = Nokogiri::HTML(open(url))
    link_record.title = html_response.title.try(:strip)
    link_record.site_data = html_response.content
    link_record.save!
    link_record
  rescue OpenURI::HTTPError => e
    p e
    link_record.save!
    link_record
  rescue ActiveRecord::StatementInvalid => e
    p e
    link_record.site_data = nil
    link_record.save!
    link_record
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
