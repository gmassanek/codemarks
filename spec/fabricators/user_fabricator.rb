Fabricator(:user) do
  authentications(:count => 1) { |user| Fabricate(:authentication, :user => user) }
end

Fabricator(:active_user, :from => :user) do
  after_create do |user|
    3.times { Fabricate(:link_save, :user => user) }
    2.times { Fabricate(:link_save, :user => user) }
  end
end

Fabricator(:user_with_private_link, :from => :user) do
  after_create do |user|
    3.times { Fabricate(:private_link_save, :user => user) }
  end
end
