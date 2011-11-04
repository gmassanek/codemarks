class SponsoredSite < ActiveRecord::Base

  module SponsoredSites
    TWITTER = "twitter"
    GITHUB = "github"

    def self.constant_values
      self.constants.collect { |c| const_get(c) }
    end
  end

  belongs_to :topic

  validates_presence_of :site, :url, :topic
  validate :site_type_valid

  def site_type_valid
    unless SponsoredSites.constant_values.include? site
      errors.add(:site, "must be a valid sponsored site") 
    end
  end

end
