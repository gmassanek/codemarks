class CodemarkRecord < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user

  has_many :codemark_topics, :dependent => :destroy
  has_many :topics, :through => :codemark_topics
  has_many :comments, :foreign_key => 'codemark_id'

  validates_presence_of :resource_id
  validates_presence_of :user_id

  scope :unarchived, where(['archived = ?', false])
  scope :by_save_date, order('created_at DESC')
  scope :by_popularity, joins(:link).order('clicks_count DESC')
  scope :for, lambda { |links| includes(:link).where(['link_id in (?)', links]) }

  delegate :url, :to => :resource

  def self.for_user_and_resource(user_id, resource_id)
    where(:user_id => user_id).where(:resource_id => resource_id).first
  end

  def resource_author
    resource.author if resource
  end

  def title
    attributes['title'] || resource.try(:title)
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
end
