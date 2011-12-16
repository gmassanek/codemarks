class Link < ActiveRecord::Base
  has_many :topics, :through => :codemarks
  has_many :codemarks, :dependent => :destroy
  has_many :clicks

  #has_many :savers, :through => :link_saves
  #has_many :clickers, :through => :link_saves

  validates_presence_of :url, :title
  validates_format_of :url, :with => URI::regexp
  
  scope :for, lambda { |codemarks| joins(:codemarks).where(['codemarks.id in (?)', codemarks]) }
end
