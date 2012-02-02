class Link < ActiveRecord::Base
  has_many :topics, :through => :codemarks
  has_many :codemarks, :dependent => :destroy
  has_many :clicks

  validates_presence_of :url, :site_content, :host, :title
end
#scope :for, lambda { |codemarks| joins(:codemarks).where(['codemarks.id in (?)', codemarks]) }
