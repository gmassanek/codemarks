class LinkRecord < ActiveRecord::Base

  attr_accessor :html_content 

  has_many :topics, :through => :codemark_records
  has_many :codemark_records
  has_many :clicks

  validates_presence_of :url, :host, :title
end
