module OOPs
  class Tagger
    class << self

      def get_tags_for_link link
        link_response = link.response
        return nil if link_response.blank?
        full_list = title_topics(link.title) | content_topics(link_response.content)
        full_list[0,5]
      end

      def title_topics(title)
        Topic.all.select { |topic| has_topic?(title, topic) }
      end

      def content_topics(content)
        Topic.all.select { |topic| has_topic?(content, topic) }
      end

      private

      def has_topic?(content, topic)
        content.gsub(/\r/, ' ').gsub(/\n/, " ").to_s.downcase.include? "#{topic.title.downcase}"
      end

    end
  end
end
