class Topic < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :sponsored_sites

end
