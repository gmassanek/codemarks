require_relative 'tagger'
require 'active_support/core_ext' #to get .blank?

module Taggable

  TAG_LIMIT = 5

  def tags
    # Codemark
    @tags = existing_tags
    return @tags if @tags.present?

    # Link
    @tags = retag
    @tags
  end

  # Codemark
  def existing_tags
    return tags_instance_variable if tags_instance_variable 
    find_tags_from_codemark
  end

  def tags_instance_variable
    @tags
  end

  # Tagger
  def retag
    tags = tagging_order.inject([]) do |tags, attribute_to_tag|
      tags << tag(self.send(attribute_to_tag)) if tags.length < TAG_LIMIT
      tags.flatten.uniq
    end
    tags.first(TAG_LIMIT)
  end

  private

  # Link
  def tag(text)
    Tagger.tag(text)
  end

  def find_tags_from_codemark
    FindTopics.existing_topics_for(self.link_record)
  end

end
