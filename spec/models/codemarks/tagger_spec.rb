require_relative '../../../app/models/codemarks/tagger'

include Codemarks

class Topic; end

describe Codemarks::Tagger do
  describe "#tag" do
    let(:titles) { ["rspec", "github", "google", "cucumber", "jquery", "another item"] }
    let(:topics) { titles.inject([]) { |topics, title| topics << stub(:title => title) } }

    before do
      Topic.stub!(:all => topics)
    end

    it "returns all the topics that are in the text" do
      text = "rspec stuff"
      rspec = topics.first
      Tagger.tag(text).should == [rspec]
    end

    it "only returns 5 tags" do
      text = titles.join(" ")
      Tagger.tag(text).count.should == 5
    end

    it "matches regardless of case" do
      rspec = topics.first
      text = rspec.title.upcase
      Tagger.tag(text).should == [rspec]
    end
  end
end
