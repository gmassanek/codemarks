class PresentCodemarks
  extend ActionView::Helpers::DateHelper

  def self.for(codemarks, current_user = nil)
    response = {
      codemarks: codemarks.select {|cm| cm.resource }.map {|codemark| present(codemark, current_user) }
    }
    response[:pagination] = present_pagination(codemarks)
    response
  end

  def self.present(codemark, current_user = nil)
    data = codemark.attributes.merge({
      resource: codemark.resource.attributes.reject { |k, _| k == 'site_data'},
      author: present_user(codemark.user),
      topics: codemark.topics.map(&:attributes)
    })
    data['title'] = codemark.title
    data
  end

  def self.present_pagination(codemarks)
    {
      :total_pages => codemarks.num_pages
    }
  end

  def self.present_user(user)
    user.attributes.merge({
      image: user.get('image')
    })
  end
end
