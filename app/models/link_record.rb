class LinkRecord < ActiveRecord::Base

  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :foreign_key => :resource_id, :as => :resource
  has_many :clicks
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  before_validation :default_title
  validates_presence_of :url, :host

  def orphan?
    author_id.blank?
  end

  def default_title
    self.title ||= ''
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end
end
