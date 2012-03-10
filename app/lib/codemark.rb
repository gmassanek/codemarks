class Codemark
  attr_accessor :resource, :topics, :type

  def taggable?
    @resource.taggable?
  end

  def self.prepare(type, resource_attrs)
    type = type

    resource = resource_class.find(resource_attrs)
    resource = resource_class.new(resource_attrs) unless resource

    topics = resource.proposed_tags
    cm = self.new(type, resource, topics)
  end

  def self.create(codemark_attrs, resource_attrs, topics_ids, user, options = {})
    link = LinkRecord.find_by_id(resource_attrs[:id])
    link ||= LinkRecord.create(resource_attrs)

    existing_codemark = CodemarkRecord.for_user_and_link(user, link)
    if existing_codemark
      combination_of_topic_ids = topics_ids | existing_codemark.topic_ids
      codemark_attrs[:topic_ids] = combination_of_topic_ids
      existing_codemark.update_attributes(codemark_attrs)
    else
      codemark_attrs[:link_record] = link
      codemark_attrs[:user] = user
      codemark_attrs[:topic_ids] = build_topics(topics_ids, options[:new_topic_titles])
      codemark_record = CodemarkRecord.create(codemark_attrs)
    end
  end

  private
  def initialize(type, resource, topics)
    @type = type
    @resource = resource
    @topics = topics
  end

  def self.resource_class
    #@type.to_s.capitalize.constantize
    #TODO Should work but constantize isn't loaded!
    Link
  end

  def self.build_topics(topic_ids, new_topic_titles)
    return topic_ids if new_topic_titles.nil?
    new_topic_titles.each do |title|
      topic_ids << Topic.create!(:title => title).id
    end
    topic_ids
  end
end
