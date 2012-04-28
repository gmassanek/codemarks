Fabricator(:codemark_record) do
  link_record!
  user!
  topics!(count: 2)
  title { Faker::Lorem.words(5).join(' ') }
end
