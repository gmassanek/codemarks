Fabricator(:codemark_record) do
  resource { Fabricate(:link_record) }
  user
  title { Faker::Lorem.words(5).join(' ') }
end
