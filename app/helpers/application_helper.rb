module ApplicationHelper

  def title
    "#{@title || params[:controller].humanize} | Codemarks"
  end

  def sign_in_path(provider)
    "/auth/#{provider.to_s}"
  end

  def bookmarklet_url
    javascript_prefix = "javascript:"
    file = File.open(File.join(Rails.root, "public", "bookmarklet.js"), "r").collect
    lines = file.collect { |line| line.strip }
    javascript_prefix + url_encode_text(lines.join(" "))
  end

  def url_encode_text(text)
    URI.escape(text, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
end
