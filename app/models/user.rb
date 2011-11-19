class User < ActiveRecord::Base

  has_secure_password

  has_many :links
  has_many :reminders

  validates_presence_of :email

end
