class Click < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true, :counter_cache => true

  validates_presence_of :resource
end
