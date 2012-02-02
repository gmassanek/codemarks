module Codemarks
  class Tagger
    def self.tag text
      Topics.all.select { |topic| text.include?(topic.title) }
    end
  end
end
