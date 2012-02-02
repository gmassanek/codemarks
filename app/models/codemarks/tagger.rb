module Codemarks
  class Tagger
    def self.tag text
      Topic.all.select { |topic| text.include?(topic.title) }
    end
  end
end
