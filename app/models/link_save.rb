class LinkSave < ActiveRecord::Base

  belongs_to :link
  belongs_to :user

  validates_presence_of :link

  after_save :calculate_link_popularity 

  def calculate_link_popularity 
    link.update_priority
  end
end
