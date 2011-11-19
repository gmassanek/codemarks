class User < ActiveRecord::Base

  has_secure_password

  has_many :links

  validates_presence_of :email

end
