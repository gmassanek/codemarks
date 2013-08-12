Fabricator(:click) do
  user { Fabricate(:user) }
  resource { Fabricate(:link) }
end
