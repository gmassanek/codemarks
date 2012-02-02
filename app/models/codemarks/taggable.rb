require_relative 'tagger'

module Codemarks
  module Taggable
    def tag
      tagging_order.each do |attr|
        Codemarks::Tagger.tag(self.send(attr))
      end
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

