class FindTopics
  def self.existing_topics_for(taggable_class, resource_id)
    resource = taggable_class.send(:find_by_id, resource_id)
    resource.topics
  end
end
