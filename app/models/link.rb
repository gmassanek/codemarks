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
    repository_for_url(url) || has_url(url).first || create_link_from_internet(url)
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

  def self.repository_for_url(url)
    if matches = url.match(/github\.com\/(?<name>\w*)\/(?<repo>[\w-]*)$/)
      name = matches['name']
      repo = matches['repo']
      if repository = Repository.new_from_login_and_repo(name, repo)
        repository.save!
        repository
      end
    end
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
    topic_ids = Tagger.tag(self.title, self.author)
    if topic_ids.length < TAG_SUGGESTION_LIMIT
      topic_ids += Tagger.tag(self.site_data, self.author)
    end
    topic_ids = topic_ids.uniq.first(TAG_SUGGESTION_LIMIT)
    Topic.where(:slug => topic_ids)
  end
end
