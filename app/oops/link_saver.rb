module OOPs
  class LinkSaver
  include Exceptions

    class << self

      def save_link!(link, options = {})
        raise LinkRequiredError if link.nil?
        raise ValidURLRequiredError  if link.url.blank?
        #raise TopicsRequiredError if topics.nil? || topics.empty?
        raise UserRequiredError  if user.nil?

        return nil unless link.valid?

        existing_link = Link.find_by_url(link.url)
        if existing_link
          link = existing_link
        else
          link.save!
        end
        create_link_save(link, user) unless user.has_saved_link? link
        #create_link_topics(link, user)
        return link
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

        def create_link_save(link, user)
          # TODO: specs are failing here because it's calling link.save somewhere in this call
          LinkSave.create!(link: link, user: user)
        end
    end
  end
end
