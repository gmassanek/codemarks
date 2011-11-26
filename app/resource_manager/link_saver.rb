module ResourceManager
  class LinkSaver

    def self.create_link(link_params, topic_ids, reminder_indicator, current_user_id)
      link = Link.find_by_url(link_params[:url])

      if link
        update_topics(link, topic_ids)
      else
        link = Link.new(link_params)
        link.topic_ids = topic_ids
        link.save
      end
      save_reminder(link, current_user_id) if reminder_indicator == "1" && current_user_id
      create_link_save(link, current_user_id)
      return link

    end

    private
      def self.save_reminder(link, user_id)
        Reminder.create(link: link, user_id: user_id)
      end

      def self.create_link_save(link, user_id)
        LinkSave.create(link: link, user_id: user_id)
      end

      def self.update_topics(link, topics)
        topics = topics.collect do |t| t.to_i end
        all_topics = link.topic_ids | topics
        link.update_attribute(:topic_ids, all_topics)
        return link
      end

  end
end
