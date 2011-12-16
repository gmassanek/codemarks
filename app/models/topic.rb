class Topic < ActiveRecord::Base
  extend FriendlyId

  paginates_per 15
  friendly_id :title, :use => :slugged

  has_many :codemark_topics
  has_many :codemarks, :through => :codemark_topics

  validates_presence_of :title
  validates_uniqueness_of :title

  scope :for_link_topics, lambda { |link_topics| joins(:link_topics).where(['"link_topics".id in (?)', link_topics]).uniq }

  #scope :by_recent_activity, select('topics.*, max("link_topics".created_at) as most_recent_date')
  #                          .joins(:link_topics)
  #                          .group('"topics".id')
  #                          .order('most_recent_date DESC')

  #scope :by_resource_count, select("topics.*, count(link_topics.id) as count")
  #                          .joins(:link_topics)
  #                          .group("topics.id")
  #                          .order("count DESC")

  #scope :join_links, joins('LEFT JOIN "link_topics" "my_link_topics" ON "my_link_topics".topic_id = "topics".id')
  #                  .joins('LEFT JOIN "links" "my_links" ON "my_links".id = "my_link_topics".link_id')
  #scope :join_link_saves, joins('LEFT JOIN "link_saves" "my_link_saves" ON "my_link_saves".link_id = "my_links".id')

  #scope :private, where(["my_links.private = ?", true])
  #scope :where_public, where(["my_links.private = ?", false])

  #scope :private_or_for_user, lambda { |user|
  #  where(['("my_link_saves".user_id = ? AND "my_links".private = ?) OR "my_links".private = ?', user.id, true, false])
  #}

  #scope :group_by_topic, group('"topics".id')  

  #def self.by_popularity
  #  select('"topics".*, max("my_links".popularity) as count').join_links.group_by_topic.order("count DESC")
  #end

  #def resource_count current_user, filter_by_mine
  #  if current_user.nil?
  #    self.links.all_public.count
  #  elsif filter_by_mine
  #    self.links.for_user(current_user).count
  #  else
  #    self.links.public_and_for_user(current_user).count
  #  end
  #end


  #def self.all_public
  #  join_links.where_public.group_by_topic
  #end

  #def self.public_and_for_user(user)
  #  user.public_and_my_topics
  #end

  #def self.for_user(user)
  #  user.topics
  #end
end

