Fabricator(:link) do
  url { Faker::Internet::http_url }
  title { Faker::Lorem::words(3).join(" ")}
end

Fabricator(:private_link, :from => :link) do
  private { true }
end

Fabricator(:private_link_topic, :from => :link_topic) do
  link! { Fabricate(:private_link) }
end
