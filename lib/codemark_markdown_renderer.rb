class CodemarkMarkdownRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::UrlHelper
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include ActionView::Helpers::AssetTagHelper

  def autolink(link, type)
    if (match = link.match(%r{\/codemarks\/(\d+?)$})) && (cm = Codemark.find_by_id(match.captures[0]))
      embeded_codemark(cm)
    else
      link_to link, link, :target => '_blank'
    end
  end

  def normal_text(text)
    matches = text.scan(/\[CM(\d+[ \w]*)\]/)

    matches.each do |match|
      id, title = match.first.match(/(\d+)[ ]*([ \w]*)/).captures
      return unless cm = Codemark.find_by_id(id)

      embedded_cm = embeded_codemark(cm, title)
      text = text.gsub(/\[CM#{match.first}\]/, embedded_cm)
    end
    text
  end

  def embeded_codemark(cm, title = nil)
    title = cm.title if title.blank?
    if cm.resource.is_a?(Link)
      link_to title, cm.resource.url, :class => 'embedded_cm', :target => '_blank'
    elsif cm.resource.is_a?(ImageFile)
      image_tag cm.resource.attachment.url
    else
      link_to title, Rails.application.routes.url_helpers.codemark_path(cm), :class => 'embedded_cm'
    end
  end
end
