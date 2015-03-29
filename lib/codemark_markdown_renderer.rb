class CodemarkMarkdownRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  def autolink(link, type)
    if (match = link.match(%r{\/codemarks\/(\d+?)$})) && (cm = Codemark.find_by_id(match.captures[0]))
      embeded_codemark(cm)
    else
      link_to link, link, :target => '_blank'
    end
  end

  def normal_text(text)
    matches = text.scan(/\[CM(\d+[ ,\w\d]*)\]/)

    matches.each do |match|
      id, data = match.first.match(/(\d+)[ ]*([ ,\w\d]*)/).captures
      return unless cm = Codemark.find_by_id(id)

      embedded_cm = embeded_codemark(cm, data)
      text = text.gsub(/\[CM#{match.first}\]/, embedded_cm)
    end
    text
  end

  def embeded_codemark(cm, data = nil)
    if cm.resource.is_a?(ImageFile)
      if data.present?
        width, height = data.split(",")
        params = {}
        params[:width] = width if width.present?
        params[:height] = height if height.present?
        image_tag cm.resource.attachment.url, params
      else
        image_tag cm.resource.attachment.url
      end
    else
      title = data.present? ? data : cm.title
      link_to title, Rails.application.routes.url_helpers.codemark_path(cm), :class => 'embedded_cm'
    end
  end
end
