module OOPs
  include Exceptions

  class SmartLink
    require 'open-uri'
    require 'nokogiri'

    attr_accessor :url, :response
    
    def initialize(url)
      valid_url_matches = url.match(URI::regexp)
      if url.blank? || !valid_url_matches 
        raise ValidURLRequiredError
      end

      @url ||= url
      @response = html_response url
    end
    
    def title
      @response.title if @response
    end

    def has_topic?(topic)
      response.content.gsub(/\r/, ' ').gsub(/\n/, " ").to_s.downcase.include? "#{topic.title.downcase}"
    end

    def topics
      Topic.all.select do |topic|
        has_topic? topic
      end
    end

    def host
      URI.parse(@url).host if @response
    end

    private

    def html_response url
      Nokogiri::HTML(open(url))
      rescue
        return nil
    end

  end

end
