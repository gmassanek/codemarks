Fabricator(:codemark) do
  resource { Fabricate(:link) }
  user
  title { Faker::Lorem.words(5).join(' ') }
end
