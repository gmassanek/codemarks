class User < ActiveRecord::Base
  has_many :authentications, :inverse_of => :user, :dependent => :destroy

  has_many :codemarks
  has_many :links, :through => :codemarks
  has_many :topics, :through => :codemarks
  has_many :clicks

  def self.find_by_email email
    id = User.select('users.id')
      .joins('LEFT JOIN authentications on users.id = authentications.user_id')
      .where(['users.email = ? OR authentications.email = ?', email, email])
      .group('users.id')
      .limit(1)
      .first
    User.find(id)
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
