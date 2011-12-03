class LinkTopic < ActiveRecord::Base

  belongs_to :link
  belongs_to :topic

  validates_presence_of :link, :topic

  scope :for_links, lambda { |links| where(['link_id in (?)', links]) }

  scope :most_recent_by_topics, select("topic_id, created_at")
                                  .order("created_at DESC")
                                  .group("topic_id")
end
