class Click < ActiveRecord::Base

  belongs_to :user
  belongs_to :link, :counter_cache => true

  validates_presence_of :link

  after_save :calculate_link_popularity 

  def calculate_link_popularity 
    link.update_priority
  end

end
