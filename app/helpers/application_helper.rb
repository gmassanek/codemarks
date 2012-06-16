module ApplicationHelper

  def sign_in_path(provider)
    "auth/#{provider.to_s}"
  end

  def bookmarklet_url
    javascript_prefix = "javascript:"
    file = File.open(File.join(Rails.root, "public", "bookmarklet.js"), "r").collect
    lines = file.collect { |line| line.strip }
    javascript_prefix + url_encode_text(lines.join(" "))
  end

  def url_encode_text text
    URI.escape(text, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def active_page_class(paths)
    paths.each do |path|
      return 'active' if current_page?(path)
    end
  end

  def sort_class(sort, default = false)
    current_sort = params[:by]
    'active' if (current_sort == sort || (!current_sort && default))
  end
end
