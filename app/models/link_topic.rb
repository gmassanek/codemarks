class LinkTopic < ActiveRecord::Base

  belongs_to :link
  belongs_to :topic

  validates_presence_of :link, :topic

  scope :for_links, lambda { |links| where(['link_id in (?)', links]) }
end
