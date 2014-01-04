require 'spec_helper'

describe Codemark do
  let(:user) { Fabricate(:user) }
  let(:link) { Fabricate(:link) }
  let(:codemark) do
    Codemark.new({
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

  describe ".update_or_create" do
    it 'creates a new codemark' do
      new_link = Fabricate(:link)
      attributes = {
        :user_id => codemark.user_id,
        :resource_type => 'Link',
        :resource_id => new_link.id,
        :title => 'Title'
      }

      expect {
        Codemark.update_or_create(attributes)
      }.to change(Codemark, :count).by(1)
    end

    it 'updates an existing codemark for that user/resource' do
      codemark.save!
      attributes = {
        :user_id => codemark.user_id,
        :resource_type => codemark.resource_type,
        :resource_id => codemark.resource_id,
        :title => 'New Title'
      }

      expect {
        Codemark.update_or_create(attributes)
      }.not_to change(Codemark, :count)
    end
  end

  describe ".most_popular_yesterday" do
    it 'is nil if there were no codemarks yesterday' do
      Codemark.most_popular_yesterday.should be_nil
    end

    it 'only picks one' do
      Fabricate(:codemark, :created_at => (Date.today-1) + 10.hours)
      Fabricate(:codemark, :created_at => (Date.today-1) + 3.hours)
      Codemark.most_popular_yesterday.should be_a Codemark
    end

    it 'picks the one first with the most clicks and saves' do
      cm1 = Fabricate(:codemark, :created_at => (Date.today-1) + 10.hours)
      cm2 = Fabricate(:codemark, :created_at => (Date.today-1) + 3.hours)
      cm3 = Fabricate(:codemark, :created_at => (Date.today-1) + 8.hours, :resource => cm2.resource)
      cm4 = Fabricate(:codemark, :created_at => (Date.today-1) + 1.hours)

      Fabricate(:click, :resource => cm3.resource)
      Fabricate(:click, :resource => cm3.resource)
      Codemark.most_popular_yesterday.id.should == cm2.id
    end
  end

  describe '#resource' do
    it 'can be a link' do
      cm = Codemark.new(:resource => link, :user => user)
      cm.resource.should == link
    end

    it 'can be a note' do
      note = Text.new(:text => 'Some Note')
      cm = Codemark.new(:resource => note, :user => user)
      cm.resource.should == note
    end
  end

  describe '#resource_author' do
    it 'is the author of its resource' do
      codemark = Fabricate.build(:codemark)
      resource = codemark.resource
      user = Fabricate(:user)
      resource.author = user
      codemark.resource_author.should == user
    end
  end

  describe "#suggested_topics" do
    before do
      @github = Topic.create!(:title => 'github')
      @rspec = Topic.create!(:title => 'rspec')
    end

    it "has none without a resource" do
      codemark = Fabricate(:codemark, :user => user)
      codemark.resource = nil
      codemark.suggested_topics.should == []
    end

    it "delegates to Link" do
      codemark = Fabricate(:codemark, :user => user)
      codemark.resource.stub(:suggested_topics => [@github, @rspec])
      codemark.suggested_topics.should == [@github, @rspec]
    end
  end

  describe '#mark_as_private' do
    before do
      @private = Topic.find_by_title('private') || Fabricate(:topic, :title => 'private')
      @codemark = codemark
      @codemark.topics = [@private]
      @codemark.save
    end

    it 'marks itself as private if it includes the private tag' do
      @codemark.should be_private
    end

    it 'marks itself as not private if it does not include the private tag' do
      codemark.topics = []
      @codemark.save
      @codemark.should_not be_private
    end
  end

  it "delegates url to it's link" do
    codemark = Fabricate.build(:codemark)
    link = codemark.resource
    codemark.url.should == link.url
  end

  it "finds codemarks for a user and a link combination" do
    user = Fabricate(:user)
    codemark = Fabricate(:codemark, :user => user)
    Codemark.for_user_and_resource(user.id, codemark.resource.id).should == codemark
  end

  describe '#group' do
  end
end
