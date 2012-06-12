class PresentCodemarks
  def self.for(codemarks)
    codemarks.map {|codemark|  present(codemark) }
  end

  def self.present(codemark)
    {
      :id => codemark.id,
      :title => {
        content: codemark.title,
        href: topic_path(codemark.id)
      },
      :topics => codemark.topics
    }
  end

  def self.topic_path(id)
    Rails.application.routes.url_helpers.topic_path(id)
  end
end
