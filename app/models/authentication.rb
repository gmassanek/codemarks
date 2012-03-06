class Authentication < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user
  validates_presence_of :provider, :uid, :nickname

  def self.find_by_provider_and_uid(provider, uid)
    find(:first, :conditions => ["provider = ? AND uid = ?", provider, uid])
  end
  
  def self.providers
    [:twitter, :github]
  end
end
