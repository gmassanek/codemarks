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

  describe ".update_or_create" do
    it 'creates a new codemark' do
      new_link = Fabricate(:link_record)
      attributes = {
        :user_id => codemark.user_id,
        :resource_type => 'LinkRecord',
        :resource_id => new_link.id,
        :title => 'Title'
      }

      expect {
        CodemarkRecord.update_or_create(attributes)
      }.to change(CodemarkRecord, :count).by(1)
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
        CodemarkRecord.update_or_create(attributes)
      }.not_to change(CodemarkRecord, :count)
    end
  end

  describe ".most_popular_yesterday" do
    it 'is nil if there were no codemarks yesterday' do
      CodemarkRecord.most_popular_yesterday.should be_nil
    end

    it 'only picks one' do
      Fabricate(:codemark_record, :created_at => (Date.today-1) + 10.hours)
      Fabricate(:codemark_record, :created_at => (Date.today-1) + 3.hours)
      CodemarkRecord.most_popular_yesterday.should be_a CodemarkRecord
    end

    it 'picks the one first with the most clicks and saves' do
      cm1 = Fabricate(:codemark_record, :created_at => (Date.today-1) + 10.hours)
      cm2 = Fabricate(:codemark_record, :created_at => (Date.today-1) + 3.hours)
      cm3 = Fabricate(:codemark_record, :created_at => (Date.today-1) + 8.hours, :resource => cm2.resource)
      cm4 = Fabricate(:codemark_record, :created_at => (Date.today-1) + 1.hours)

      Fabricate(:click, :link_record => cm3.resource)
      Fabricate(:click, :link_record => cm3.resource)
      CodemarkRecord.most_popular_yesterday.id.should == cm2.id
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

  it "delegates url to it's link" do
    codemark = Fabricate.build(:codemark_record)
    link = codemark.resource
    codemark.url.should == link.url
  end

  it "finds codemarks for a user and a link combination" do
    user = Fabricate(:user)
    codemark_record = Fabricate(:codemark_record, :user => user)
    CodemarkRecord.for_user_and_resource(user.id, codemark_record.resource.id).should == codemark_record
  end
end
