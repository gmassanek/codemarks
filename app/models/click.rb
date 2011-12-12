class Click < ActiveRecord::Base

  belongs_to :user
  belongs_to :link, :counter_cache => true

  validates_presence_of :link

end
