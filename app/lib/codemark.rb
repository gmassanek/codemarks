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

  def self.create(codemark_attrs, resource_attrs, topics_ids, user)
    link = LinkRecord.create(resource_attrs)
    codemark_attrs[:link_record] = link
    codemark_attrs[:topic_ids] = topics_ids
    codemark_attrs[:user] = user
    codemark_record = CodemarkRecord.create(codemark_attrs)
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
end
