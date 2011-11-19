Fabricator(:reminder) do
  user { Fabricate(:user) }
  link { Fabricate(:link) }
end
