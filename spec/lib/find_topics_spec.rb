require 'spec_helper'

describe FindTopics do
  describe "#existing_topics_for" do
    let(:cm) { Fabricate(:codemark_record) }
    let(:resource) { cm.link_record }
    let!(:cm2) { Fabricate(:codemark_record, :link_record => resource) }

    it "finds all codemarks for the given resource" do
      topics = FindTopics.existing_topics_for(LinkRecord, resource)
      topics.collect(&:id).should == cm.topics.collect(&:id) | cm2.topics.collect(&:id)
    end

    it "doesn't include duplicate topics" do
      one_topic = Fabricate(:topic)
      two_topic = [Fabricate(:topic), Fabricate(:topic)] 
      has_one_topic = Fabricate(:codemark_record, :topic_ids => [one_topic.id])
      same_resource = has_one_topic.link_record
      has_two_topic = Fabricate(:codemark_record, 
                                :topics => two_topic, 
                                :link_record => same_resource)

      topics = FindTopics.existing_topics_for(LinkRecord, same_resource)
      topics.collect(&:id).should == [one_topic.id, two_topic.first.id, two_topic.last.id]
    end

    it "can scope by user"
  end
end
