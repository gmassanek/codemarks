Fabricator(:authentication) do
  provider { "twitter" }
  uid { rand(999999).to_s }
  name { Faker::Name.name }
  nickname { Faker::Internet.user_name.sub(".", "_") }
  email { Faker::Internet.email }
  user
end
