require_relative 'tagger'

module Taggable

  def proposed_tags
    if self.id
      tags = existing_tags
      return tags if tags && tags.length > 0
    end
    tags = []
    tagging_order.each do |attr|
      text_to_tag = self.send(attr)
      if text_to_tag && tags.length < 5
        pos_tags = Tagger.tag(text_to_tag)
        tags = tags | pos_tags unless pos_tags.nil?
      end
    end
    tags.first(Tagger::TAG_LIMIT)
  end

  def taggable?
    true
  end

  def existing_tags
    resource = LinkRecord.find(self.id)
    FindTopics.existing_topics_for(resource)
  end

end
