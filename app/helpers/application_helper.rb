module ApplicationHelper

  def title
    "#{params[:controller].humanize.capitalize} | Codemarks"
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

  def tweet_out_link(codemark)
    author = codemark.user
    if author.id == current_user.id
      short_user_url(current_user)
    else
      #"http://www.codemarks.com/public"
      public_codemarks_url
    end
  end

  def codemark_short_tag_list(codemark)
    tags = codemark.topics.first(3)
    if tags
      tag_texts = tags.collect do |tag|
        "##{tag.slug}"
      end
      tag_texts.join(" ")
    else
      ""
    end
  end

  def tweet_text(codemark)
    author = codemark.user
    tags = codemark_short_tag_list(codemark)
    message = 'Have you seen this? '
    sign_off = ' via @codemarks'
    message_length = message.size + 20 + tags.size + sign_off.size + 10
    title_length = 140 - message_length
    title = codemark.title || codemark.resource.title
    if title.length > title_length
      title = title[0, title_length] + '...'
    end

    text = %!#{message}#{codemark.url} - "#{title}" #{tags}!
    url_encode_text(text)
  end
end
