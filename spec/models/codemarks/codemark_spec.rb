'fast_specs'

require_relative '../../../app/models/codemarks/codemark'
require_relative '../../../app/models/codemarks/link'
include Codemarks

describe Codemark do
  let(:valid_url) { "http://www.example.com" }

  describe "#initialize" do
    it "creates a link on initialize" do
      link = mock(Codemarks::Link)
      Codemarks::Link.should_receive(:new).with(valid_url).and_return(link)
      cm = Codemarks::Codemark.new(valid_url)
      cm.link.should == link
    end
  end

  describe "#commit", :skip => true do
    #it "commits its link on commit" do
    #  link = mock
    #  mock(::Link, :create => link)
    #  cm = Codemark.new
    #  cm.commit
    #end
  end

end
