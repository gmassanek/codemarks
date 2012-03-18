class FindTopics
  def self.existing_topics_for(resource)
    if resource.persisted?
      resource.persisted_object.send(:topics)
    else
      []
    end
  end
end
