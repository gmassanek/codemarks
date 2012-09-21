Fabricator(:codemark_record) do
  resource! { Fabricate(:link_record) }
  user!
  topics!(count: 2)
  title { Faker::Lorem.words(5).join(' ') }
end
