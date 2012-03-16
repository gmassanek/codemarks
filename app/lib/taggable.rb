require_relative 'tagger'

module Taggable

  TAG_LIMIT = 5

  def tags
    @tags = existing_tags
    return @tags if @tags

    @tags = find_existing_tags
    return @tags if @tags

    @tags = retag
  end

  def existing_tags
    @tags
  end

  def find_existing_tags
    FindTopics.existing_topics_for(self) if self.persisted?
  end

  def retag
    tags = tagging_order.inject([]) do |tags, attribute_to_tag|
      tags << tag(self.send(attribute_to_tag)) if tags.length < TAG_LIMIT
      tags.flatten.uniq
    end
    tags.first(TAG_LIMIT)
  end

  def tag(text)
    Tagger.tag(text)
  end

end
