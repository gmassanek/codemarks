class LinkSave < ActiveRecord::Base

  belongs_to :link, :counter_cache => true
  belongs_to :user

  validates_presence_of :link
  validates_presence_of :user

  scope :unarchived, where(['archived = ?', false])
  scope :by_save_date, order('created_at DESC')

  delegate :title, :url, :to => :link
end
