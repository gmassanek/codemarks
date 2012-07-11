class LinkRecord < ActiveRecord::Base

  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :foreign_key => :resource_id
  has_many :clicks
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  validates_presence_of :url, :host, :title

  def orphan?
    author_id.blank?
  end
end
