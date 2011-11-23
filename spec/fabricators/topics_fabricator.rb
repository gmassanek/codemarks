Fabricator(:topic) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.paragraphs(3).join(" ") }
end

Fabricator(:topic_with_sponsored_links, :from => :topic) do
  sponsored_sites!(:count => 3) { |topic, i| Fabricate(:sponsored_site, 
                                                       :topic => topic, 
                                                       :site => SponsoredSite::SponsoredSites.constant_values[i-1]) }
end
