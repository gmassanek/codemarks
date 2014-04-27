class Tagger
  TAG_SUGGESTION_LIMIT = 3

  def self.tag(text, user = nil)
    return [] if text.blank?
    words = sanitize(text).scan(/\w+/).each_with_object(Hash.new{ |i| 0 }){ |w,h| h[w] += 1}

    Topic.for_user(user).select('title, slug').group_by { |t| sanitize(t.title) }.
      select { |k, v| words.include?(k) }.
      sort_by { |k, v| words[k] }.
      map { |(k, v)| v[0].slug }.
      reverse
  end

  private

  def self.sanitize(text)
    text.downcase
  end
end
