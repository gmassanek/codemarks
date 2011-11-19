class Reminder < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :link

  validates_presence_of :user, :link

end
