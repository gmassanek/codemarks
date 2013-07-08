class Codemark

  attr_writer :tags, :title
  attr_accessor :id, :resource, :user, :codemark_record, :tag_ids, :url, :description

  def initialize(attributes = {})
    @id = attributes[:id]
    @resource = attributes[:resource]
    @tags = attributes[:tags]
    @user = attributes[:user] || User.find_by_id(attributes[:user_id])

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
    return self if codemark_by_id

    @resource = Link.load(url: @url)
    load_users_codemark
    self
  end

  def codemark_by_id
    @codemark_record = CodemarkRecord.find_by_id(@id)
    pull_up_attributes if @codemark_record
    @codemark_record.present?
  end

  def load_users_codemark
    return unless @user && @resource
    @codemark_record = CodemarkRecord.for_user_and_resource(@user.id, @resource.id)
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
    codemark.user = User.find_by_id(options[:user_id])
    codemark.save_to_database
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

  private

  def save_codemark_record(resource_attributes)
    resource.update_attributes(resource_attributes)
  end

  def self.private_topic
    Topic.find_by_title('private')
  end
end
