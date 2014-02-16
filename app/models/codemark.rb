class Codemark < ActiveRecord::Base
  belongs_to :resource, :counter_cache => true
  belongs_to :user
  belongs_to :group

  has_many :codemark_topics, :dependent => :destroy
  has_many :topics, :through => :codemark_topics

  has_many :comments, :foreign_key => 'codemark_id'

  validates_presence_of :resource_id
  validates_presence_of :user_id

  before_save :mark_as_private
  after_create :track

  def self.for_user_and_resource(user_id, resource_id)
    find(:first, :conditions => {:user_id => user_id, :resource_id => resource_id})
  end

  def self.update_or_create(attributes)
    cm = for_user_and_resource(attributes[:user_id], attributes[:resource_id]) || Codemark.new
    cm.update_attributes(attributes)
    cm.resource.update_author(attributes[:user_id])
    cm
  end

  def self.most_popular_yesterday
    Codemark.where("DATE(codemarks.created_at) = ?", Date.today - 1).
      joins(:resource).
      where(:private => false).
      where(:group_id => nil).
      order('(resources.codemarks_count + resources.clicks_count) DESC, codemarks.created_at ASC').
      first
  end

  def resource_author
    resource.author if resource
  end

  def title
    attributes['title'] || resource.try(:title)
  end

  def resource_type
    resource.try(:type)
  end

  def resource_type_underscore
    resource_type.underscore
  end

  def suggested_topics
    return [] unless resource

    case resource.class.to_s
    when 'Link'
      resource.suggested_topics
    when 'Text'
      []
    else
      []
    end
  end

  def mark_as_private
    self.private = self.topics.map(&:id).include?(Topic.private_topic_id)
    true
  end

  def tracking_data
    {
      :topics => self.topics.map(&:slug),
      :resource_id => self.resource_id,
      :resource_type => self.resource_type,
      :group_id => self.group_id,
      :group => self.group.try(:name),
      :source => self.source
    }
  end

  def track
    Global.track(:user_id => self.user.nickname, :event => 'codemark_created', :properties => tracking_data)
  end
end
