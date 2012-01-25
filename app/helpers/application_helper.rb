module ApplicationHelper

  def sign_in_path(provider)
    "auth/#{provider.to_s}"
  end

  def bookmarklet_url
    javascript_prefix = "javascript:"
    file = File.open(File.join(Rails.root, "public", "bookmarklet.js"), "r").collect
    lines = file.collect { |line| line.strip }
    escaped = javascript_prefix + URI.escape(lines.join(" "), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    user_id = current_user_id
    user_id ||= 0
    with_user_id = escaped.gsub("USER_ID", user_id.to_s)
    javascript_prefix + with_user_id
  end
end
