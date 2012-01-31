require 'nokogiri'
require 'open-uri'

module Codemarks
  class Link
    attr_accessor :link_record, :site_response, :url, :site_content, :host, :title

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

    def commit
      create_link_record
    end

    private

    def create_link_record
      @link_record = ::Link.create(url: @url, site_content: @site_content, host: @host, title: @title)
    end
  end
end
