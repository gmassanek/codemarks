Fabricator(:authentication) do
  provider { "twitter" }
  uid { rand(999999).to_s }
  name { Faker::Name.name }
  email { Faker::Internet.email }
  user!
end
