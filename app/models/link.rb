require 'nokogiri'
require 'open-uri'
require 'postrank-uri'

class Link < Resource
  hstore_attr :site_data, :snapshot_url, :snapshot_id
  hstore_indexed_attr :title, :url, :host

  TAG_SUGGESTION_LIMIT = 3

  before_validation :default_title, :default_host
  after_create :trigger_snapshot
  validates_presence_of :url, :host

  def self.for_url(url)
    url = PostRank::URI.clean(url)
    has_url(url).first || create_link_from_internet(url)
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
  rescue OpenURI::HTTPError, ActiveRecord::StatementInvalid, RuntimeError => e
    p e
    link.update_attributes(:site_data => nil)
    link
  end

  def default_title
    self.title ||= '(No title)'
  end

  def default_host
    self.host = URI.parse(url).host unless self.host.present?
  end

  def trigger_snapshot
    return unless url && id
    return if snapshot_id

    Delayed::Job.enqueue(SnapLinkJob.new(self))
  end

  def suggested_topics
    topics = Tagger.tag(self.title)
    return topics.first(TAG_SUGGESTION_LIMIT) if topics.length >= TAG_SUGGESTION_LIMIT

    topics += Tagger.tag(self.site_data)
    topics.uniq.first(TAG_SUGGESTION_LIMIT)
  end
end
