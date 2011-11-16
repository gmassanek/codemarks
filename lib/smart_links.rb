module SmartLinks

  class MyCurl
    require 'net/http'

    def self.get_title_content(url)
      body = get_body(url)
      title_tag = body.scan(/<title>(.*?)<\/title>/)[0]
      if title_tag.present?
        return title_tag[0]
      else
        return url
      end
    end

    def self.get_possible_topics(url)
      body = get_body(url).downcase
      topics = Topic.all
      matched_topics = []
      topics.each do |topic|
        matched_topics << topic if body.include? topic.title.downcase
      end
      matched_topics
    end

    private
    def self.get_body(url)
      Net::HTTP.get(URI(url))
    end
  end

end
