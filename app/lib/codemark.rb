class Codemark

  attr_writer :tags, :title
  attr_accessor :id, :resource, :user, :codemark_record, :tag_ids, :url, :description

  def initialize(attributes = {})
    @id = attributes[:id]
    @resource = attributes[:resource]
    @tags = attributes[:tags]
    @user = attributes[:user]
    @user = Codemark.look_for_user(attributes) if attributes[:user_id]

    @codemark_record = attributes[:codemark_record]

    @title = attributes[:title]
    @description = attributes[:description]

    @url = attributes[:url]
  end

  def resource
    @resource || link_record
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
    @resource = @codemark_record.resource
    @tags = @codemark_record.topics
    @title = @codemark_record.title
    if @user == @codemark_record.user.inspect
      @id = @codemark_record.id
      @user = @codemark_record.user
      @description = @codemark_record.description
    end
  end

  def tags
    @tags || @resource.tags
  end

  def attributes
    @codemark_record.try(&:attributes) || {}
  end

  def topics
    tags
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
    codemark.tag_ids = tag_ids
    codemark.user = Codemark.look_for_user(options)
    codemark.save_to_database
  end

  # assume a resource_id is always coming in
  def self.create(attributes, options = {})
    codemark_record = existing_codemark(attributes[:user_id], attributes[:resource_id])
    attributes[:private] = private?(attributes[:topic_ids])
    if codemark_record
      codemark_record.update_attributes(attributes)
    else
      codemark_record = CodemarkRecord.create!(attributes)
    end
    codemark_record.resource.update_author(attributes[:user_id])
    codemark_record
  end

  def self.private?(topic_ids)
    topic_ids.include? private_topic.try(:id).to_s
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
                          :resource_id => codemark_record.resource_id,
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
        :resource_id => @resource.id,
        :topic_ids => tags.collect(&:id)
      })
    end
    if self.codemark_record.save!
      @id = self.codemark_record.id
    end
    self
  end

  def self.existing_codemark(user_id, resource_id)
    CodemarkRecord.for_user_and_resource(user_id, resource_id)
  end

  private

  def load_codemark_by_id(id)
    CodemarkRecord.find(id)
  end

  def load_link
    Link.load(url: @url)
  end

  def self.look_for_user(options)
    User.find_by_id(options[:user_id])# || User.find_by_email(options[:email_address])
  end

  def load_codemark_for_user
    if @user && @resource
      cm = CodemarkRecord.find(:first, :conditions => {:user_id => @user.id, :resource_id => @resource.id})
      cm
    end
  end

  def save_resource
    resource.save
  end

  def save_codemark_record(resource_attributes)
    resource.update_attributes(resource_attributes)
  end

  def self.private_topic
    Topic.find_by_title('private')
  end
end
