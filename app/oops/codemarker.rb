module OOPs
  class Codemarker
  include Exceptions

    class << self

      def mark!(codemark)
        raise LinkRequiredError if codemark.link.nil?
        raise InvalidLinkError unless codemark.link.valid?
        raise UserRequiredError if codemark.user.nil?
        #raise TopicsRequiredError if topics.nil? || topics.empty?

        link = codemark.link
        existing_link = Link.find_by_url(link.url)
        if existing_link
          link = existing_link
        else
          link.save!
        end

        existing_codemark = codemark.user.codemark_for(codemark.link)
        if existing_codemark
          existing_codemark.topics = codemark.topics
          existing_codemark.save
        else
          if codemark.save
            return codemark
          end
        end
      end

      private
        def create_link_topics(link, topics)
          create_new_topics(user, topics)
          cur_topics = link.topics
          topics.reject! { |topic| cur_topics.include? topic }
          topics.each do |topic|
            LinkTopic.create!(link: link, user: user, topic: topic)
          end
        end

        def create_new_topics(user, topics)
          topics.each do |topic|
            topic.save! if topic.new_record?
          end
        end
    end
  end
end
