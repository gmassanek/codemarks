module OOPs
  class Tagger
    class << self

      def get_tags_for_link link
        return nil if link.response.nil?
        return topics link.response
      end

      def has_topic?(response, topic)
        response.content.gsub(/\r/, ' ').gsub(/\n/, " ").to_s.downcase.include? "#{topic.title.downcase}"
      end

      def topics response
        Topic.all.select do |topic|
          has_topic? response, topic
        end
      end
    end
  end
end
