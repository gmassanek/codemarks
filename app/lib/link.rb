require_relative 'taggable'
require 'nokogiri'
require 'open-uri'

class Link
  include Taggable
  attr_accessor :url, :site_content, :host, :title, :link_record, :site_response, :valid_url

  def initialize(link_attributes = {})
    @url = link_attributes[:url]
    @site_response = gathers_site_data
    parse_site_response
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

  def self.create(link_attrs)
    @link_record = LinkRecord.create(link_attrs)
    @link_record
  end

  def valid_url?
    self.valid_url
  end

  def tagging_order
    [:title, :site_content]
  end
end
