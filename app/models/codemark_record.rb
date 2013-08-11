class CodemarkRecord < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user

  has_many :codemark_topics, :dependent => :destroy
  has_many :topics, :through => :codemark_topics
  has_many :comments, :foreign_key => 'codemark_id'

  validates_presence_of :resource_id
  validates_presence_of :user_id

  scope :by_save_date, order('created_at DESC')
  scope :by_popularity, joins(:resource).order('clicks_count DESC')
  scope :for, lambda { |links| includes(:resource).where(['resource_id in (?)', links]) }

  delegate :url, :to => :resource
  before_save :mark_as_private

  def self.for_user_and_resource(user_id, resource_id)
    find(:first, :conditions => {:user_id => user_id, :resource_id => resource_id})
  end

  def self.update_or_create(attributes)
    cm = for_user_and_resource(attributes[:user_id], attributes[:resource_id]) || CodemarkRecord.new
    cm.update_attributes(attributes)
    cm.resource.update_author(attributes[:user_id])
    cm
  end

  def self.most_popular_yesterday
    candidates = CodemarkRecord.where(["DATE(created_at) = ?", Date.today-1])
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
    when 'LinkRecord'
      resource.suggested_topics
    when 'TextRecord'
      []
    else
      []
    end
  end

  def mark_as_private
    self.private = self.topics.map(&:id).include?(Topic.private_topic_id)
    true
  end
end
