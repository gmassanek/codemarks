class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :sponsored_sites, :inverse_of => :topic, :dependent => :destroy
  accepts_nested_attributes_for :sponsored_sites, :reject_if => lambda {|s| s[:url].blank? || s[:site].blank? }
end
