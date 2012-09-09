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
    data = {
      resource: codemark.resource.attributes,
      author: codemark.user.attributes,
      topics: codemark.topics.map(&:attributes)
    }.merge(codemark.attributes)
    data['title'] = codemark.title
    data
  end

  def self.present_pagination(codemarks)
    {
      :total_pages => codemarks.num_pages
    }
  end
end
