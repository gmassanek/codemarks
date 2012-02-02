module Codemarks
  class Codemark
    attr_accessor :link, :tags

    def initialize(url=nil)
      @link = Codemarks::Link.new(url)
      @tags = @link.tag
    end

    def commit
      @link.commit
    end

    def taggable?
      @link.taggable?
    end
  end
end
