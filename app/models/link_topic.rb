class LinkTopic < ActiveRecord::Base

  belongs_to :link
  belongs_to :topic

  validates_presence_of :link, :topic

end
