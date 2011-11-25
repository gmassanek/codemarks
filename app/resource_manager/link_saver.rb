module ResourceManager
  class LinkSaver

    def self.create_new_link(params)
      link = Link.find_by_url(params[:link][:url])

      if link
        link = increment_saves(link)
        update_topics(link, params[:topic_ids])
      else
        link = Link.new(params[:link])
        link.topic_ids = params[:topic_ids]
        link.save
      end
      save_reminder(link, params[:link][:user_id]) if params[:reminder] == "1" && params[:link][:user_id]
      return link

    end

    private
      def self.save_reminder(link, user_id)
        Reminder.create(link: link, user_id: user_id)
      end

      def self.increment_saves(link)
        link.update_attribute(:save_count, link.save_count + 1)
        return link
      end

      def self.update_topics(link, topics)
        topics = topics.collect do |t| t.to_i end
        all_topics = link.topic_ids | topics
        link.update_attribute(:topic_ids, all_topics)
        return link
      end

  end
end
