class Codemark

  attr_writer :tags, :title
  attr_accessor :id, :resource, :user, :codemark_record, :tag_ids, :url, :note

  def initialize(attributes = {})
    @id = attributes[:id]
    @resource = attributes[:resource]
    @tags = attributes[:tags]
    @user = attributes[:user]
    @user = Codemark.look_for_user(attributes) if attributes[:user_id]

    @codemark_record = attributes[:codemark_record]

    @title = attributes[:title]
    @note = attributes[:note]

    @url = attributes[:url]
  end

  def self.load(attributes = {})
    codemark = Codemark.new(attributes)
    codemark.load
  end

  def load
    return self if load_requested_codemark

    @resource = load_link
    load_users_codemark
    self
  end

  def load_requested_codemark
    @codemark_record = load_codemark_by_id(@id) if @id.present?
    pull_up_attributes if @codemark_record
    @codemark_record.present?
  end

  def load_users_codemark
    @codemark_record = load_codemark_for_user
    pull_up_attributes if @codemark_record
  end

  def pull_up_attributes
    @resource = @codemark_record.link_record
    @tags = @codemark_record.topics
    @title = @codemark_record.title
    if @user == @codemark_record.user.inspect
      @id = @codemark_record.id
      @user = @codemark_record.user
      @note = @codemark_record.note
    end
  end

  def tags
    @tags || @resource.tags
  end

  def title
    @title || @resource.title
  end
  
  def resource_class
    @resource_type.to_s.capitalize.constantize
  end

  def save
    load_users_codemark
    save_to_database
  end

  def self.save(attributes, tag_ids, options = {})
    codemark = Codemark.load(attributes)
    codemark.tag_ids = tag_ids | handle_new_topics(options[:new_topics])
    codemark.user = Codemark.look_for_user(options)
    codemark.save_to_database
  end

  def self.create(codemark_attrs, resource_attrs, topics_ids, user, options = {})
    link = LinkRecord.find_by_id(resource_attrs[:id])
    link ||= LinkRecord.create(resource_attrs)

    existing_codemark = CodemarkRecord.for_user_and_link(user, link)
    topic_ids = build_topics(topics_ids, options[:new_topic_titles])

    codemark_attrs[:private] = true if topic_ids.include? private_topic.id

    codemark_attrs.delete(:resource)
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
    link.update_author(user.id)
  end

  def self.build_and_create(user, resource_type, resource_attrs)
    prepared_codemark = prepare(resource_type, resource_attrs)

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

  def save_to_database
    # TODO messy and should be private and smaller

    user_id = @user.id if @user
    if self.codemark_record
      self.codemark_record.update_attributes({
        :topic_ids => tags.collect(&:id)
      })
    else
      self.codemark_record = CodemarkRecord.new({
        :user_id => user_id,
        :link_record_id => @resource.id,
        :topic_ids => tags.collect(&:id)
      })
    end
    if self.codemark_record.save!
      @id = self.codemark_record.id
    end
    self
  end

  private

  def load_codemark_by_id(id)
    CodemarkRecord.find(id)
  end

  def load_codemark_by_link_and_id(user, link)
    CodemarkRecord.find_by_user_and_link(user, link)
  end

  # NEED TO TEST THESE CONNECTIONS??
  #
  def load_link
    Link.load(url: @url)
  end

  def self.handle_new_topics(topic_titles)
    return [] unless topic_titles
    topic_titles.inject([]) do |topic_ids, title|
      topic_ids << Topic.create!(:title => title).id
    end
  end

  def self.look_for_user(options)
    User.find_by_id(options[:user_id])# || User.find_by_email(options[:email_address])
  end

  def load_codemark_for_user
    if @user && @resource
      cm = CodemarkRecord.find(:first, :conditions => {:user_id => @user.id, :link_record_id => @resource.id})
      cm
    end
  end

  def save_resource
    resource.save
  end

  def save_codemark_record(resource_attributes)
    resource.update_attributes(resource_attributes)
  end

  def self.build_topics(topic_ids, new_topic_titles)
    return topic_ids if new_topic_titles.nil?
    new_topic_titles.each do |title|
      topic_ids << Topic.create!(:title => title).id
    end
    topic_ids
  end

  def self.private_topic
    Topic.find_by_title('private')
  end
end
