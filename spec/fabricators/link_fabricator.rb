Fabricator(:link) do
  url { Faker::Internet::http_url }
  title { Faker::Lorem::words(6).join(" ")}
end
