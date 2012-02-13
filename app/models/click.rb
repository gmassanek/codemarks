class Click < ActiveRecord::Base

  belongs_to :user
  belongs_to :link_record, :counter_cache => true

  validates_presence_of :link_record

end
