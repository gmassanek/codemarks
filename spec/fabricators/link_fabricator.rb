Fabricator(:link) do
  url { Faker::Internet::http_url }
  site_content { Faker::HTMLIpsum::body}
  host { Faker::Internet::domain_name}
  title { Faker::Lorem::words(6).join(" ")}
end
