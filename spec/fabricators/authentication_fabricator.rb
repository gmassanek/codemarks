Fabricator(:authentication) do
  provider { "twitter" }
  uid { rand(999999).to_s }
  user!
end
