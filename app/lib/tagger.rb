class Tagger
  def self.tag(text)
    return [] if text.blank?
    matches = Topic.all.select do |t| 
      text = sanitize(text)
      term = sanitize(t.title)
      text[/\b#{term}\b/]
    end
  end

  private

  def self.sanitize(text)
    text.downcase
  end
end
