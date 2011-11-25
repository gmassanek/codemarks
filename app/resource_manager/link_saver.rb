module ResourceManager
  class LinkSaver

    def self.save_link(link_params, topic_ids, reminder_indicator, current_user_id)
      link = Link.find_by_url(link_params[:url])

      if link
        update_topics(link, topic_ids)
      else
        link = create_link(link_params, topic_ids)
      end

      create_reminder(link, current_user_id) if reminder_indicator == "1" && current_user_id
      create_user_topics(topic_ids, current_user_id) if current_user_id
      create_link_save(link, current_user_id)

      link
    end

    private
      def self.create_user_topics(topic_ids, current_user_id)
        topic_ids.each do |topic_id|
          UserTopic.create(:user_id => current_user_id, :topic_id => topic_id)
        end
      end

      def self.create_link(link_params, topic_ids)
        link = Link.new(link_params)
        link.topic_ids = topic_ids
        return link if link.save
      end

      def self.create_reminder(link, user_id)
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
