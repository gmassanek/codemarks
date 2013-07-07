class TextRecord < ActiveRecord::Base
  has_many :topics, :through => :codemark_records
  has_many :codemark_records, :as => :resource
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  validates :text, :presence => true
end
