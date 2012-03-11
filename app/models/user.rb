class User < ActiveRecord::Base

  has_many :authentications, :inverse_of => :user, :dependent => :destroy
  has_many :codemark_records
  has_many :links, :through => :codemark_records
  has_many :topics, :through => :codemark_records
  has_many :clicks

  #validates_presence_of :nickname

  after_save :take_nickname_from_authentication

  def self.find_by_email email
    id = User.select('users.id')
      .joins('LEFT JOIN authentications on users.id = authentications.user_id')
      .where(['users.email = ? OR authentications.email = ?', email, email])
      .group('users.id')
      .limit(1)
      .first
    User.find_by_id(id)
  end

  def self.find_by_authentication(provider, nickname)
    User.find(:first,
              :joins => :authentications,
              :conditions => {:authentications => {:provider => provider, :nickname => nickname}}
             )
  end

  def take_nickname_from_authentication
    nickname = authentications.first.nickname
    self.nickname = nickname
  end

  def authentication_by_provider provider
    authentications.find(:first, :conditions => ["provider = ?", provider])
  end

  def missing_authentications
    current_providers = authentications.collect(&:provider)
    missing = Authentication.providers.reject! do |provider|
      current_providers.include?(provider.to_s)
    end
    missing
  end

  def codemark_for link
    codemarks.for(link).first
  end

  def get attr
    val = self.send attr
    if val
      return val
    else
      auth_vals = authentications.collect { |auth| auth.send attr }
      return auth_vals.compact.first
    end
  end
end
