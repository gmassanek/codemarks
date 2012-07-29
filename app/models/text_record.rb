class TextRecord < ActiveRecord::Base
  has_many :codemark_records, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  validates_presence_of :text

  def orphan?
    author_id.blank?
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end
end
