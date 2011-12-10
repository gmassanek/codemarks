class LinkSave < ActiveRecord::Base

  belongs_to :link, :counter_cache => true
  belongs_to :user

  validates_presence_of :link
  validates_presence_of :user

end
