class Click < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :counter_cache => true

  validates_presence_of :resource
end
