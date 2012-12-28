Fabricator(:click) do
  user { Fabricate(:user) }
  link_record { Fabricate(:link_record) }
end
