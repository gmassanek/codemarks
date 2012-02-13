module Codemarks
  class Tagger
    def self.tag text
      Topic.all.select! do |topic| 
        text.downcase.include?(topic.title.downcase)
      end
    end
  end
end
