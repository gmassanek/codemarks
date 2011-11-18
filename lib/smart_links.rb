module SmartLinks

  class MyCurl
    require 'net/http'
    attr_accesor :url
    
    def initialize(url)
      @url ||= url
    end
    
    def head
      header_tag = body.scan(/<head>(.*?)<\/head>/)[0]
      header_tag.present? ? header_tag[0] : url
    end
    
    def body
      get_body(url)
    end

    def self.get_head_content(url)
      header_tag = body.scan(/<head>(.*?)<\/head>/)[0]
      if header_tag.present?
        return header_tag[0]
      else
        return url
      end
    end

    def self.get_title_content(url)
      title_tag = body.scan(/<title>(.*?)<\/title>/)[0]
      if title_tag.present?
        return title_tag[0]
      else
        return url
      end
    end

    def head_has_topic?(topic)
      head.include? topic
    end
    
    def body_has_topic?(topic)
      body.include? topic
    end

    def has_topic?(topic)
      response.include? topic
    end

    def self.get_possible_topics(url)
      matched_topics = []
      Topic.all.each do |topic|
        matched_topics << topic if has_topic?(topic)
      end  

      # body = get_body(url).downcase
      # topics = Topic.all
      # matched_topics = []
      # topics.each do |topic|
      #   matched_topics << topic if body.include? topic.title.downcase
      # end
      # matched_topics
    end

    private
    def self.response
      Net::HTTP.get_response(URI(url)).body
    end
  end

end
