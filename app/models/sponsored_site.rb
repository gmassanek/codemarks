class SponsoredSite < ActiveRecord::Base

  module SponsoredSites
    TWITTER = "twitter"
    GITHUB = "github"
    RUBYGEMS = "rubygems"
    RUBYGUIDES = "guides.rubyonrails"
    RAILSCASTS = "railscasts"
    RUBYDOC = "rubydoc"

    def self.constant_values
      self.constants.collect { |c| const_get(c) }
    end
  end

  belongs_to :topic, :inverse_of => :sponsored_sites

  validates_presence_of :site, :url, :topic
  validates_format_of :url, :with => URI::regexp

  validate :site_type_valid
  validate :site_is_for_type

  def site_type_valid
    unless SponsoredSites.constant_values.include? site
      errors.add(:site, "must be a valid sponsored site") 
    end
  end

  def site_is_for_type
    return if url.blank? || site.blank?
    unless url.include? site
      errors.add(:url, "must be for the selected site type") 
    end
  end

end
