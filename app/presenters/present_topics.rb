class PresentTopics
  def self.for(topics)
    topics.map { |topic| present(topic) }.sort_by { |data| data[:title] }
  end

  def self.present(topic)
    {
      description: topic.description,
      slug: topic.slug,
      title: topic.title
    }
  end
end
