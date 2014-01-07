class PresentCodemarks
  extend ActionView::Helpers::DateHelper

  def self.for(codemarks, current_user = nil, searched_user = nil)
    response = {
      codemarks: codemarks.select {|cm| cm.resource }.map {|codemark| present(codemark, current_user) }
    }
    response[:pagination] = present_pagination(codemarks)
    response[:users] = present_users(codemarks, current_user, searched_user)
    response
  end

  def self.present(codemark, current_user = nil)
    if current_user == codemark.user
      user = codemark.user
    else
      user = codemark.resource_author || codemark.user
    end

    data = codemark.attributes.slice('id', 'user_id', 'resource_id', 'resource_type', 'created_at', 'updated_at', 'description', 'title', 'group_id', 'private', 'save_count', 'visit_count')
    data.merge!({
      resource: codemark.resource.attributes.except('site_data', 'search', 'snapshot_id'),
      author: present_user(user),
      topics: codemark.topics.map(&:attributes)
    })
    data['title'] = codemark.title || 'No title'
    data
  end

  def self.present_pagination(codemarks)
    {
      :total_pages => codemarks.num_pages
    }
  end

  def self.present_users(codemarks, current_user, searched_user)
    users = codemarks.map(&:user)
    users << current_user
    users << searched_user
    users.compact.uniq.map do |user|
      present_user(user)
    end
  end

  def self.present_user(user)
    return unless user
    {
      id: user.id,
      name: user.get('name'),
      nickname: user.get('nickname'),
      slug: user.slug,
      image: user.get('image')
    }
  end
end
