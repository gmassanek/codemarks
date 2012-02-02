require_relative '../../../app/models/codemarks/tagger'

class Topics; end

describe Codemarks::Tagger do
  describe "#tag" do
    it "returns all the topics that are in the text" do
      text = "Here is some stuff"
      matching_topic = stub(:title => "some")
      random_topic = stub(:title => "rspec")
      Topics.stub!(:all => [matching_topic, random_topic])
      Codemarks::Tagger.tag(text).should == [matching_topic]
    end
  end
end
