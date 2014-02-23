class PresentUsers
  def self.present(user)
    return unless user
     {
      id: user.id,
      name: user.get('name'),
      nickname: user.get('nickname'),
      slug: user.slug,
      image: user.get('image'),
      groups: user.groups.map { |user| present_group(user) }
    }
  end

  def self.present_group(group)
    {
      id: group.id,
      name: group.name
    }
  end
end
