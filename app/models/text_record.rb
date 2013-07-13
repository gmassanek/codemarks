class TextRecord < ActiveRecord::Base
  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :as => :resource
  has_many :clicks, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  validates :text, :presence => true

  def orphan?
    author_id.blank?
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end
end
