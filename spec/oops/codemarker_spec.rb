require 'spec_helper'

describe Codemarker do
  let (:codemark) { Fabricate.build(:codemark) }
  let (:github) { Fabricate(:topic, :title => "Github") }
  let (:rspec) { Fabricate(:topic, :title => "Rspec") }
  let (:link) { Fabricate.build(:link) }
  let (:user) { Fabricate(:user) }
  let (:topics) { [github, rspec] }

  context "#mark!" do

    describe "requires" do
      it "a link object" do
        codemark.stub!(:link).and_return(nil)
        lambda {
          Codemarker.mark!(codemark)
        }.should raise_error(LinkRequiredError)
      end

      it "a valid link object" do
        codemark.link.stub!(:valid?).and_return(false)
        lambda {
          Codemarker.mark!(codemark)
        }.should raise_error(InvalidLinkError)
      end

      it "a user" do
        codemark.stub!(:user).and_return(nil)
        lambda {
          Codemarker.mark!(codemark)
        }.should raise_error(UserRequiredError)
      end
    end

    context "saves the link" do
      it "if it is a link" do
        codemark.link = Fabricate.build(:link)
        codemark.link.should_receive(:save!)
        Codemarker.mark!(codemark)
      end

      it "unless it is an existing link" do
        duplicate_link = codemark.link
        duplicate_link.should_not_receive(:save!)
        Codemarker.mark!(Fabricate.build(:codemark, link: duplicate_link))
      end

      it "and returns it on successful save" do
        Codemarker.mark!(codemark).id.should 
      end
    end

    context "creates a new codemark" do
      it "if I have not saved this link before" do
        codemark.should_receive(:save!)
        Codemarker.mark!(codemark)
      end
      
      it "even if another user has saved the link before" do
        Fabricate(:codemark, link: codemark.link)

        codemark.should_receive(:save!)
        Codemarker.mark!(codemark)
      end

      it "unless I have saved this link before" do
        codemark.save

        codemark.should_not_receive(:save)
        Codemarker.mark!(codemark)
      end
    end

    context "creates new codemark_topics" do
      let(:topics) { [Fabricate(:topic), Fabricate(:topic)] }

      it "if I have not tagged the link with a topic before" do
        codemark.topics = topics
        lambda {
          Codemarker.mark!(codemark)
        }.should change(CodemarkTopic, :count).by(topics.count)
      end

      it "only for the topics I have not already associated to that link" do
        codemark = Fabricate.build(:codemark)
        topics = [Fabricate(:topic), Fabricate(:topic)]
        codemark.topics = topics
        Codemarker.mark!(codemark)
        link = codemark.link

        topics << Fabricate(:topic)
        new_codemark = Fabricate.build(:codemark, link: codemark.link, user: codemark.user, topics: topics)

        Codemarker.mark!(new_codemark)
        CodemarkTopic.count.should == 3
      end

      it "deletes CodemarkTopics on update" do
        codemark = Fabricate.build(:codemark)
        topics = [Fabricate(:topic), Fabricate(:topic)]
        codemark.topics = topics
        Codemarker.mark!(codemark)

        topics = [topics.first]
        new_codemark = Fabricate.build(:codemark, link: codemark.link, user: codemark.user, topics: topics)

        Codemarker.mark!(new_codemark)

        CodemarkTopic.count.should == 1
        Codemark.find(codemark.id).topics.count.should == 1
      end
    end

    it "creates new topics if the topic has not been saved before" do
      hats = Fabricate.build(:topic, :title => "Hats that I want")
      topics = codemark.topics
      topics << hats
      
      lambda {
        Codemarker.mark!(codemark)
      }.should change(Topic, :count).by(1)
    end

    it "doesn't use a trailing / on a link" do
      codemark.save
      url = codemark.link.url + "/"
      link = Fabricate.build(:link, url: url)

      codemark2 = Codemark.new(link: link, user: codemark.user, topics: codemark.topics)
      codemark2 = Codemarker.mark!(codemark2)
      codemark2.link.should == codemark.link
    end
  end
end
