class Tagger
  def self.tag(text)
    return [] if text.blank?
    matches = Topic.all.select do |t| 
      sanitize(text).include?(sanitize(t.title))
    end
  end

  private

  def self.sanitize(text)
    text.downcase
  end
end
