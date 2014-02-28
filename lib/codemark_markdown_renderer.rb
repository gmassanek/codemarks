class CodemarkMarkdownRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::UrlHelper

  def autolink(link, type)
    if (match = link.match(%r{\/codemarks\/(\d+?)$})) && (cm = Codemark.find_by_id(match.captures[0]))
      embeded_codemark_link(cm)
    else
      link_to link, link, :target => '_blank'
    end
  end

  def normal_text(text)
    matches = text.scan(/\[CM(\d+[ \w]*)\]/)

    matches.each do |match|
      id, title = match.first.match(/(\d+)[ ]*([ \w]*)/).captures
      return unless cm = Codemark.find_by_id(id)

      link = embeded_codemark_link(cm, title)

      text = text.gsub(/\[CM#{match.first}\]/, link)
    end
    text
  end

  def embeded_codemark_link(cm, title = nil)
    title = cm.title if title.blank?
    if cm.resource.is_a?(Link)
      link_to title, cm.resource.url, :class => 'embedded_cm', :target => '_blank'
    else
      link_to title, Rails.application.routes.url_helpers.codemark_path(cm), :class => 'embedded_cm'
    end
  end
end
