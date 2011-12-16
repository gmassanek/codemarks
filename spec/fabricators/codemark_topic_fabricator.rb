Fabricator(:codemark_topic) do
  codemark! { Fabricate(:link_save) }
  topic!
end
