require_relative 'tagger'

module Codemarks
  module Taggable
    def proposed_tags
      tagging_order.collect do |attr|
        taggable_attribute_text = self.send(attr)
        tags = Tagger.tag(taggable_attribute_text) unless taggable_attribute_text.nil?
      end.flatten.uniq
    end

    def taggable?
      true
    end
  end
end

    #def self.included(base)
    #  base.extend(ClassMethods)
    #end
    #module ClassMethods
    #  def taggable?
    #    true
    #  end
    #end

