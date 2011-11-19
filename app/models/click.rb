class Click < ActiveRecord::Base

  belongs_to :user
  belongs_to :link

  validates_presence_of :link

  before_create :update_reminder

  def update_reminder
    reminder = self.link.reminders.unfinished.for_user(self.user.id)
    reminder.first.close unless reminder.empty?
  end

end
