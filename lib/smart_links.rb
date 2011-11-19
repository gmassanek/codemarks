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
      matched_topics = []
      Topic.all.each do |topic|
        matched_topics << topic if has_topic?(topic)
      end  
    end

  end

end
