require_relative 'taggable'
require 'nokogiri'
require 'open-uri'

class Link
  include Taggable
  attr_accessor :id, :url, :site_content, :host, :title, :link_record, :site_response, :valid_url

  def initialize(link_attributes = {})
    @url = link_attributes[:url]
    @site_response = gathers_site_data
    parse_site_response
  end

  def self.create(link_attrs)
    @link_record = LinkRecord.create(link_attrs)
    @link_record
  end

  def self.find(link_attrs)
    link_record = LinkRecord.find_by_url(link_attrs[:url])
    from_link_record(link_record) if link_record
  end

  def self.from_link_record(link_record)
    link = Link.new
    link.url = link_record.url
    link.host = link_record.host
    link.title = link_record.title
    link.id = link_record.id
    link
  end

  def gathers_site_data
    @valid_url = true
    return Nokogiri::HTML(open(url))
  rescue Exception => e
    @valid_url = false
    return nil
  end

  def parse_site_response
    return unless site_response
    @title = site_response.title
    @site_content = site_response.content
    @host = URI.parse(url).host if url
  end

  def valid_url?
    self.valid_url
  end

  def tagging_order
    [:title, :site_content]
  end

  def resource_attrs
    {
      :url => @url,
      :host => @host,
      :title => @title
    }
  end

  def persisted?
    link_record.persisted?
  end
end
