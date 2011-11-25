class LinkSave < ActiveRecord::Base

  belongs_to :link
  belongs_to :user

  validates_presence_of :link

end
