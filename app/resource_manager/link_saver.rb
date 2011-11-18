module ResourceManager
  class LinkSaver

    def self.create_new_link(params)
      link = Link.find_by_url(params[:link][:url])

      if link
        puts link.inspect
        increment_saves(link) && update_topics(link, params[:topic_ids])
        return link
      else
        link = Link.new(params[:link])
        link.topic_ids = params[:topic_ids]
        link.save
      end
      return link

    end

    private
      def self.increment_saves(link)
        link.update_attribute(:save_count, link.save_count + 1)
        return link
      end

      def self.update_topics(link, topics)
        topics = topics.collect do |t| t.to_i end
        puts link.topic_ids.inspect
        puts topics.inspect
        puts (link.topic_ids || topics).inspect
        link.update_attribute(:topic_ids, (link.topic_ids || topics))
        return link
      end

  end
end
