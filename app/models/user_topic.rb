class UserTopic < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  validates_presence_of :user, :topic

  scope :for, lambda { |user_id| where(['user_id = ?', user_id]) }

end
