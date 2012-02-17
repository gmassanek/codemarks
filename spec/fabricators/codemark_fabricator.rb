Fabricator(:codemark_record) do
  link_record!
  user!
  topics!(count: 2)
end
