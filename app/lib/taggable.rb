require_relative 'tagger'

module Taggable

  def proposed_tags
    unless self.id.nil?
      return existing_tags
    end
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
    FindCodemarks.for_resource(self.class, self.id)
  end

end
