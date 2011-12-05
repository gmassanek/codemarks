class Click < ActiveRecord::Base

  belongs_to :user
  belongs_to :link

  validates_presence_of :link

  before_create :update_reminder
  after_save :calculate_link_popularity 

  def calculate_link_popularity 
    link.update_priority
  end

  def update_reminder
    return if self.user.nil?
    reminder = self.link.reminders.unfinished.for_user(self.user.id)
    reminder.first.close unless reminder.empty?
  end

end
