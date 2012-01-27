require 'nokogiri'
require 'open-uri'

class Link

  attr_accessor :url, :site_response, :site_content, :host, :title

  def initialize(url)
    @url = url
    @site_response = gathers_site_data
    parse_site_response
  end

  def gathers_site_data
    Nokogiri::HTML(open(url))
  rescue Exception => e
  end

  def parse_site_response
    return unless site_response
    @title = site_response.title
    @site_content = site_response.content
    @host = URI.parse(url).host
  end
end


#scope :for, lambda { |codemarks| joins(:codemarks).where(['codemarks.id in (?)', codemarks]) }
