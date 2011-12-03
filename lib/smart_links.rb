module SmartLinks

  class MyCurl
    require 'open-uri'
    require 'nokogiri'

    attr_accessor :url, :response
    
    def initialize(url)
      @url ||= url
      @response = html_response url
    end
    
    def title
      response.title if response
    end

    def has_topic?(topic)
      response.to_s.downcase.include? topic.title.downcase
    end

    def topics
      Topic.all.select do |topic|
        has_topic? topic
      end
    end

    private

    def html_response url
      Nokogiri::HTML(open(url))
    end

  end

end
