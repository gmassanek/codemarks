require_relative 'tagger'

module Codemarks
  module Taggable
    def tag
      tagging_order.collect do |attr|
        Codemarks::Tagger.tag(self.send(attr))
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

