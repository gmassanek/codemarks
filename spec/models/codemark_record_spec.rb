require 'spec_helper'

describe CodemarkRecord do
  context "requires" do
    [:link_record, :user].each do |field|
      it "a #{field}" do
        codemark = Fabricate.build(:codemark_record, field => nil)
        codemark.should_not be_valid
      end
    end
  end

  describe '#resource_author' do
    it 'is the author of its resource' do
      codemark = Fabricate.build(:codemark_record)
      resource = codemark.link_record
      user = Fabricate(:user)
      resource.author = user
      codemark.resource_author.should == user
    end
  end
  
  it "is unarchived by default" do
    Fabricate.build(:codemark_record).should_not be_archived
  end

  it "retrieves unarchived link saves" do
    new_ls = Fabricate(:codemark_record, archived: false)
    old_ls = Fabricate(:codemark_record, archived: true)
    CodemarkRecord.unarchived.should == [new_ls]
  end

  it "delegates url to it's link" do
    codemark = Fabricate.build(:codemark_record)
    link = codemark.link_record
    codemark.url.should == link.url
  end

  it "has topics through codemarks (link saves)" do
    codemark = Fabricate(:codemark_record)
    codemark.topics.should_not be_blank
  end

  it "creates CodemarkTopics on save" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    lambda {
      codemark.save
    }.should change(CodemarkTopic, :count).by(topics.count)
  end

  it "creates CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    topics << Fabricate(:topic)
    codemark.topics = topics
    codemark.save!

    CodemarkTopic.count.should == 3
  end

  it "deletes CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    codemark.topics = [topics.first]
    codemark.save!

    CodemarkTopic.count.should == 1
    CodemarkRecord.find(codemark.id).topics.count.should == 1
  end

  it "creates new topics for any that don't exist yet" do
    codemark = Fabricate.build(:codemark_record)
    hats = Fabricate.build(:topic, :title => "Hats that I want")
    topics = codemark.topics
    topics << hats
    
    lambda {
      codemark.save!
    }.should change(Topic, :count).by(1)
  end

  it "finds all codemarks for a link"

  it "finds codemarks for a user and a link combination" do
    user = Fabricate(:user)
    codemark_record = Fabricate(:codemark_record, :user => user)
    CodemarkRecord.for_user_and_link(user, codemark_record.link_record).should == codemark_record
  end
end
