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

    data = codemark.attributes.slice('id', 'user_id', 'resource_id', 'created_at', 'updated_at', 'description', 'title', 'group_id', 'private', 'save_count', 'visit_count')
    data['title'] = codemark.title || 'No title'
    data['resource_type'] = codemark.resource_type

    data.merge!({
      resource: present_resource(codemark.resource),
      topics: codemark.topics.map(&:attributes),
      editable: UserCodemarkAuthorizer.new(current_user, codemark, :edit).authorized?,
      user: PresentUsers.present(codemark.user)
    })
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
      PresentUsers.present(user)
    end
  end

  def self.present_resource(resource)
    attrs = {
      'id' => resource.id,
      'clicks_count' => resource.clicks_count,
      'codemarks_count' => resource.codemarks_count,
      'type' => resource.type,
      'author_id' => resource.author_id
    }
    if resource.is_a?(Text)
      attrs['text'] = resource.text
      attrs['html'] = Global.render_markdown(resource.text)
    elsif resource.is_a?(Link)
      attrs['url'] = resource.url
      attrs['host'] = resource.host
      attrs['snapshot_url'] = resource.snapshot_url
    end
    attrs['user'] = PresentUsers.present(resource.author) if resource.author
    attrs
  end
end
