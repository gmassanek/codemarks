Fabricator(:topic) do
  title { Faker::Lorem.words(3).join(" ") }
  description { Faker::Lorem.paragraphs(2).join(" ") }
end

Fabricator(:topic_with_sponsored_links, :from => :topic) do
  sponsored_sites!(:count => 3) { |topic, i| Fabricate(:sponsored_site, 
                                                       :topic => topic, 
                                                       :site => SponsoredSite::SponsoredSites.constant_values[i-1]) }
end
