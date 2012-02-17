class Tagger

  TAG_LIMIT = 5

  def self.tag(text)
    matches = Topic.all.select do |t| 
      sanitize(text).include?(sanitize(t.title))
    end
    matches.first(TAG_LIMIT)
  end

  private

  def self.sanitize(text)
    text.downcase
  end
end
