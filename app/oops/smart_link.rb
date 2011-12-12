module OOPs
  include Exceptions

  class SmartLink
    require 'open-uri'
    require 'nokogiri'

    attr_accessor :url, :response
    
    def initialize(url)
      raise ValidURLRequiredError if url.blank?
      @url ||= url
      @response = html_response url
      raise ValidURLRequiredError if @response.nil?
    end
    
    def title
      @response.title
    end

    def has_topic?(topic)
      #response.to_s.downcase.include? " #{topic.title.downcase}"
      response.content.gsub(/\r/, ' ').gsub(/\n/, " ").to_s.downcase.include? "#{topic.title.downcase}"
    end

    def topics
      Topic.all.select do |topic|
        has_topic? topic
      end
    end

    private

    def html_response url
      Nokogiri::HTML(open(url))
      rescue
        return nil
    end

  end

end
