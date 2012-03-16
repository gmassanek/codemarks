class Codemark
  attr_accessor :resource, :topics, :type

  def self.prepare(type, resource_attrs)
    type = type

    existing_resource = resource_class.find(resource_attrs)
    if existing_resource.nil? || existing_resource.tags.length == 0
      resource = resource_class.new(resource_attrs)
      resource.id = existing_resource.id if existing_resource
    end

    resource ||= existing_resource

    topics = resource.tags
    cm = self.new(type, resource, topics)
  end

  def self.create(codemark_attrs, resource_attrs, topics_ids, user, options = {})
    link = LinkRecord.find_by_id(resource_attrs[:id])
    link ||= LinkRecord.create(resource_attrs)

    existing_codemark = CodemarkRecord.for_user_and_link(user, link)
    topic_ids = build_topics(topics_ids, options[:new_topic_titles])
    if existing_codemark
      combination_of_topic_ids = topics_ids
      codemark_attrs[:topic_ids] = combination_of_topic_ids
      existing_codemark.update_attributes(codemark_attrs)
      existing_codemark.link_record.update_attributes(resource_attrs)
    else
      codemark_attrs[:link_record] = link
      codemark_attrs[:user] = user
      codemark_attrs[:topic_ids] = topic_ids
      codemark_record = CodemarkRecord.create(codemark_attrs)
    end
  end

  def self.build_and_create(user, type, resource_attrs)
    prepared_codemark = prepare(type, resource_attrs)

    Codemark.create({},
                    prepared_codemark.resource.resource_attrs,
                    prepared_codemark.topics.collect(&:id),
                    user)
  end

  def self.steal(codemark_record, user)
    CodemarkRecord.create(:user => user, 
                          :link_record_id => codemark_record.link_record_id, 
                          :topic_ids => codemark_record.topic_ids)
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
