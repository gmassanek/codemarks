class LinkTopic < ActiveRecord::Base

  belongs_to :link
  belongs_to :topic
  belongs_to :user

  validates_presence_of :link, :topic, :user

  scope :for_links, lambda { |links| where(['link_id in (?)', links]) }

  scope :most_recent_by_topics, select("topic_id, created_at")
                                  .order("created_at DESC")
                                  .group("topic_id")
end
