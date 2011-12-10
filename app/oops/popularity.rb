module OOPs
  class LinkPopularity
    def self.calculate link
      link.clicks_count + link.link_saves_count
    end
  end
end
