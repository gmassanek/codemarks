module Codemarks
  module Taggable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def taggable?
        true
      end
    end

    def taggable?
      true
    end
  end
end
