require_relative 'taggable'
require 'nokogiri'
require 'open-uri'

class Link
  include Taggable
  attr_accessor :id, :url, :site_data, :host, :title, :link_record, :site_response, :valid_url, :author_id

  def initialize(attributes = {})
    return if attributes.blank?
    self.id = attributes[:id]
    self.url = attributes[:url]
    self.author_id = attributes[:author_id]
  end

  def load
    self.link_record = load_link_record
    self
  end

  def self.load(attributes = {})
    link = Link.new(attributes)
    link.load
  end

  def load_link_record
    return link_record if link_record
    self.link_record ||= find_existing_link_record
    self.link_record ||= create_link_record_from_internet

    self.id = link_record.id
    self.url = link_record.url
    self.title = link_record.title
    self.host = link_record.host
    self.author_id = link_record.author_id
    self.site_data = link_record.site_data

    link_record
  end

  def find_existing_link_record
    link_record = Link.find_link_record_by_id(self.id) if self.id
    link_record ||= Link.find_link_record_by_url(self.url) if self.url
    link_record
  end

  # need to refactor
  def create_link_record_from_internet
    link_record = LinkRecord.new
    html_response = parsed_html_response(url)

    link_record.url = self.url
    link_record.title = html_response.title
    link_record.host = URI.parse(url).host
    link_record.site_data = html_response.content
    link_record.save!
    link_record
  rescue Exception => e
    p e
    return nil
  end

  #should pass this off to Tagger via Tagger.tag_these([:title, :html_content])
  def tagging_order
    [:title, :site_data]
  end

  def orphan?
    author_id.blank?
  end

  def update_author(author_id = nil)
    @author_id = author_id if author_id
    persist_author if orphan?
  end

  private

  def self.find_link_record_by_id(id)
    LinkRecord.find_by_id(id)
  end

  def self.find_link_record_by_url(url)
    LinkRecord.find_by_url(url)
  end

  def parsed_html_response(url)
    Nokogiri::HTML(open(url))
  end

  def persist_author
    LinkRecord.update_attributes(:author_id => author_id)
  end
end
