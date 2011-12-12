require 'spec_helper'

describe OOPs::LinkSaver do
  let (:github) { Fabricate(:topic, :title => "Github") }
  let (:rspec) { Fabricate(:topic, :title => "Rspec") }
  let (:link) { Fabricate.build(:link) }
  let (:user) { Fabricate(:user) }
  let (:topics) { [github, rspec] }
  let (:duplicate_link) { Fabricate.build(:link, url: link.url) }

  context "#save_link!" do

    describe "requires" do
      it "a link object" do
        lambda {
          OOPs::LinkSaver.save_link!(nil, user, topics)
        }.should raise_error(LinkRequiredError)
      end

      it "a link object with a url" do
        link = Fabricate.build(:link, url: nil)
        lambda {
          OOPs::LinkSaver.save_link!(link, user, topics)
        }.should raise_error(ValidURLRequiredError)
      end

      it "a valid link" do
        link.url = "adf"
        OOPs::LinkSaver.save_link!(link, user, topics).should be_nil
        link.errors.should include(:url)
      end

      it "a list of topics" do
        lambda {
          OOPs::LinkSaver.save_link!(link, user, nil)
        }.should raise_error(TopicsRequiredError)
        lambda {
          OOPs::LinkSaver.save_link!(link, user, [])
        }.should raise_error(TopicsRequiredError)
      end

      it "a user" do
        lambda {
          OOPs::LinkSaver.save_link!(link, nil, topics)
        }.should raise_error(UserRequiredError)
      end
    end

    context "saves the link" do
      it "if it is a new url" do
        link.should_receive(:save!)
        OOPs::LinkSaver.save_link!(link, user, topics)
      end

      it "unless it is an existing url" do
        link.save
        duplicate_link.should_not_receive(:save!)
        OOPs::LinkSaver.save_link!(duplicate_link, user, topics)
      end

      it "and returns it on successful save" do
        OOPs::LinkSaver.save_link!(link, user, topics).should == link
      end
    end

    context "creates a new link_save" do
      it "if I have not saved this link before" do
        LinkSave.should_receive(:create!)
        OOPs::LinkSaver.save_link!(link, user, topics)
      end
      
      it "even if another user has saved the link before" do
        another_user = Fabricate(:user)
        OOPs::LinkSaver.save_link!(link, another_user, topics)

        LinkSave.should_receive(:create!)
        OOPs::LinkSaver.save_link!(link, user, topics)
      end

      it "unless I have saved this link before" do
        OOPs::LinkSaver.save_link!(link, user, topics)

        LinkSave.should_not_receive(:create!)
        OOPs::LinkSaver.save_link!(link, user, topics)
      end
    end

    context "creates new user_link_topics" do
      it "if I have not tagged the link with a topic before" do
        LinkTopic.should_receive(:create!).twice
        OOPs::LinkSaver.save_link!(link, user, topics)
      end

      it "only for the topics I have not already associated to that link" do
        OOPs::LinkSaver.save_link!(link, user, topics)
        facebook = Fabricate(:topic, title: "Facebook")

        LinkTopic.should_receive(:create!)
        OOPs::LinkSaver.save_link!(link, user, [facebook])
      end

      it "unless I have tagged the link with a topic before" do
        OOPs::LinkSaver.save_link!(link, user, topics)

        LinkTopic.should_not_receive(:create!)
        OOPs::LinkSaver.save_link!(link, user, topics)
      end
    end

    it "creates new topics if the topic has not been saved before" do
      hats = Fabricate.build(:topic, :title => "Hats that I want")
      topics << hats
      hats.should_receive(:save!)
      OOPs::LinkSaver.save_link!(link, user, topics)
    end
  end
end
