class Authentication < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :provider, :uid
  validates_presence_of :user

  def self.find_by_provider_and_uid(provider, uid)
    find(:first, :conditions => ["provider = ? AND uid = ?", provider, uid])
  end
end
