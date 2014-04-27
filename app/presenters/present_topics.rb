class PresentTopics
  def self.for(topics)
    topics.map { |topic| present(topic) }
  end

  def self.present(topic)
    {
      description: topic.description,
      slug: topic.slug,
      title: topic.title
    }
  end
end
