class Reminder < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :link

  validates_presence_of :user, :link

  scope :unfinished, where(['completed = ?', false])
  scope :finished, where(['completed = ?', true])
  scope :for_user, lambda {|user_id| where(["user_id = ?", user_id])}
  scope :for_link, lambda {|link_id| where(["link_id = ?", link_id])}

  def close
    self.update_attribute(:completed, true)
  end

end
