module SmartLinks

  class MyCurl
    require 'open-uri'
    require 'nokogiri'

    attr_accessor :url, :response
    
    def initialize(url)
      @url ||= url
      @response = Nokogiri::HTML(open(url))
    end
    
    def title
      response.title
    end

    def has_topic?(topic)
      response.to_s.downcase.include? topic.title.downcase
    end

    def topics
      Topic.all.select do |topic|
        has_topic? topic
      end
    end

  end

end
