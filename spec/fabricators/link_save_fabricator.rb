Fabricator(:link_save) do
  link!
  user!
  topics!(count: 3)
end

Fabricator(:private_link_save, :class_name => :link_save) do
  link! { Fabricate(:private_link) }
  user!
  after_create do |link_save|
    Fabricate(:link_topic, :link => link_save.link)
  end
end

