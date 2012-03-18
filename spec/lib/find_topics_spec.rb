require_relative '../../app/lib/find_topics'

describe FindTopics do
  describe "#existing_topics_for" do

    it "returns an empty array if the resource is not persisted" do
      resource = mock(:'persisted?' => false)
      topics = FindTopics.existing_topics_for(resource).should == []
    end

    it "finds all codemarks for the given resource" do
      topics = [stub, stub]
      persisted_object = mock(:topics => topics)

      resource = mock({
        :'persisted?' => true,
        :persisted_object => persisted_object
      })

      FindTopics.existing_topics_for(resource).should == topics
    end
  end
end
