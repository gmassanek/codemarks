module Codemarks
  class Codemark
    attr_accessor :link

    def initialize(url=nil)
      @link = Codemarks::Link.new(url)
    end

    def commit
      @link.commit
    end
  end
end
