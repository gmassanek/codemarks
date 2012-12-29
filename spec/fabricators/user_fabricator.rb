Fabricator(:user) do
  authentications(:count => 1) { |user| Fabricate(:authentication) }
end

Fabricator(:twitter_user, :class_name => "user") do
  authentications(:count => 1) { |user| Fabricate(:authentication, :provider => "twitter") }
end

Fabricator(:github_user, :class_name => "user") do
  authentications(:count => 1) { |user| Fabricate(:authentication, :provider => "github") }
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
