class Codemark < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user
  belongs_to :group

  has_many :codemark_topics, :dependent => :destroy
  has_many :topics, :through => :codemark_topics

  has_many :comments, :foreign_key => 'codemark_id'

  validates_presence_of :resource_id
  validates_presence_of :user_id

  delegate :url, :to => :resource
  before_save :mark_as_private
  before_create :set_group
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
    candidates = Codemark.where(["DATE(created_at) = ?", Date.today-1])
    return unless candidates.present?

    candidates.max_by do |codemark|
      clicks = codemark.resource.clicks_count
      saves = candidates.select { |cm| cm.resource == codemark.resource }.count
      saves + count
    end
  end

  def resource_author
    resource.author if resource
  end

  def title
    attributes['title'] || resource.try(:title)
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

  def set_group
    self.group ||= Group::DEFAULT
  end

  def track
    params = {
      :topics => self.topics.map(&:slug)
    }
    Global.track(:user_id => self.user.nickname, :event => 'codemark_created', :properties => params)
  end
end
