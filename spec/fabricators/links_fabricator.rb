Fabricator(:link) do
  url { Faker::Internet::http_url }
  title { Faker::Lorem::words(3).join(" ")}
end

Fabricator(:link_topic) do
  link!
  topic!
end
