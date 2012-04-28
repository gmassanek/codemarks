class Comment < ActiveRecord::Base
  belongs_to :codemark, :foreign_key => :codemark_id
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  validates_presence_of :codemark_id, :author_id, :text
end
