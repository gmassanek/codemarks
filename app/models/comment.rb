class Comment < ActiveRecord::Base
  validates_presence_of :codemark_id, :author_id, :text
end
