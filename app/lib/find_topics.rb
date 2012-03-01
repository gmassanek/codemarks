class FindTopics
  def self.existing_topics_for(resource)
    resource.send(:topics)
  end
end
