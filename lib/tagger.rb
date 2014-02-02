class Tagger
  def self.tag(text, user = nil)
    return [] if text.blank?
    text = sanitize(text)
    tag_matches = {}
    Topic.for_user(user).each do |topic|
      term = sanitize(topic.title)
      matches = text.scan(/\b#{term}\b/)
      next unless matches.present?
      tag_matches[topic] = matches.count
    end
    tag_matches.keys.sort { |x, y| tag_matches[y] <=> tag_matches[x] }
  end

  private

  def self.sanitize(text)
    text.downcase
  end
end
