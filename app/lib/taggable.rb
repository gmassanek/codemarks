require_relative 'tagger'

module Taggable

  def proposed_tags
    return existing_tags if self.id
    tags = []
    tagging_order.each do |attr|
      text_to_tag = self.send(attr)
      if !text_to_tag.nil? && tags.length < 5
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
    FindTopics.existing_topics_for(LinkRecord, self.id)
  end

end
