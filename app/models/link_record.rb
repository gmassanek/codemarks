class LinkRecord < ActiveRecord::Base
  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :as => :resource
  has_many :clicks, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  before_validation :default_title
  after_create :trigger_snapshot
  validates_presence_of :url, :host

  def orphan?
    author_id.blank?
  end

  def default_title
    self.title ||= '(No title)'
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end

  def trigger_snapshot
    return unless url && id
    Delayed::Job.enqueue(SnapLinkJob.new(self))
  end
end
