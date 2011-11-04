Fabricator(:topic) do
  title { Faker::Lorem.word }
end

Fabricator(:topic_with_sponsored_links, :from => :topic) do
  sponsored_sites!(:count => 3) { |topic, i| Fabricate(:sponsored_site, :topic => topic) }
end
