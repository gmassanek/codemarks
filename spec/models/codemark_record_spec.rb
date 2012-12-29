require 'spec_helper'

describe CodemarkRecord do
  let(:user) { Fabricate(:user) }
  let(:link) { Fabricate(:link_record) }
  let(:codemark) do
    CodemarkRecord.new({
      :resource => link,
      :user => user,
      :topics => [Fabricate(:topic), Fabricate(:topic)]
    })
  end

  context "requires" do
    it "a resource" do
      codemark.resource = nil
      codemark.should_not be_valid
    end

    it "a user" do
      codemark.user = nil
      codemark.should_not be_valid
    end
  end

  describe '#resource' do
    it 'can be a link_record' do
      cm = CodemarkRecord.new(:resource => link, :user => user)
      cm.resource.should == link
    end

    it 'can be a note' do
      note = TextRecord.new(:text => 'Some Note')
      cm = CodemarkRecord.new(:resource => note, :user => user)
      cm.resource.should == note
    end
  end

  describe '#resource_author' do
    it 'is the author of its resource' do
      codemark = Fabricate.build(:codemark_record)
      resource = codemark.resource
      user = Fabricate(:user)
      resource.author = user
      codemark.resource_author.should == user
    end
  end

  describe 'can be archive' do
    it "is unarchived by default" do
      codemark.should_not be_archived
    end

    it "retrieves unarchived link saves" do
      new_ls = Fabricate(:codemark_record, archived: false)
      old_ls = Fabricate(:codemark_record, archived: true)
      CodemarkRecord.unarchived.should == [new_ls]
    end
  end

  it "delegates url to it's link" do
    codemark = Fabricate.build(:codemark_record)
    link = codemark.resource
    codemark.url.should == link.url
  end

  it "creates CodemarkTopics on save" do
    lambda {
      codemark.save!
    }.should change(CodemarkTopic, :count).by(codemark.topics.length)
  end

  it "creates CodemarkTopics on update" do
    codemark.save!
    codemark.topics << Fabricate(:topic)
    codemark.save!

    CodemarkTopic.count.should == 3
  end

  it "deletes CodemarkTopics on update" do
    codemark.save!
    codemark.topics = [codemark.topics.first]
    codemark.save!

    CodemarkTopic.count.should == 1
    CodemarkRecord.find(codemark.id).topics.count.should == 1
  end

  it "creates new topics for any that don't exist yet" do
    hats = Fabricate.build(:topic, :title => "Hats that I want")
    codemark.topics = [hats]
    
    expect {
      codemark.save!
    }.should change(Topic, :count).by(1)
  end

  it "finds codemarks for a user and a link combination" do
    user = Fabricate(:user)
    codemark_record = Fabricate(:codemark_record, :user => user)
    CodemarkRecord.for_user_and_resource(user.id, codemark_record.resource.id).should == codemark_record
  end
end
