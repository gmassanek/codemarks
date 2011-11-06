Fabricator(:link) do
  url { Faker::Internet::http_url }
end

Fabricator(:link_topic) do
  link!
  topic!
end
