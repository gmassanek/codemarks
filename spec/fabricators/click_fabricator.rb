Fabricator(:click) do
  user { Fabricate(:user) }
  link { Fabricate(:link) }
end
