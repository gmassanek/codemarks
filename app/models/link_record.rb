class LinkRecord < ActiveRecord::Base
  set_table_name "links"
  has_many :topics, :through => :codemarks
  has_many :codemarks, :dependent => :destroy
  has_many :clicks

  validates_presence_of :url, :host, :title
end
#scope :for, lambda { |codemarks| joins(:codemarks).where(['codemarks.id in (?)', codemarks]) }
