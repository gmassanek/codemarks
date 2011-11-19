class Reminder < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :link

  validates_presence_of :user, :link

  scope :unfinished, where(['completed = ?', false])
  scope :finished, where(['completed = ?', true])
  scope :for_user, lambda {|user_id| where(["user_id = ?", user_id])}

  def close
    puts "Closing"
    puts self.inspect
    self.update_attribute(:completed, true)
    puts self.inspect
  end

end
