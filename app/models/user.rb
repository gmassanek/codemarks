class User < ActiveRecord::Base

  has_many :authentications, :inverse_of => :user, :dependent => :destroy

  has_many :link_saves, :class_name => 'LinkSave', :foreign_key => 'user_id'
  has_many :links, :through => :link_saves
  has_many :topics, :through => :link_saves#, :uniq => true
  has_many :clicks

  #validates_presence_of :authentications

  def authentication_by_provider provider
    authentications.find(:first, :conditions => ["provider = ?", provider])
  end

  def has_saved_link? link
    links.include? link
  end

end
