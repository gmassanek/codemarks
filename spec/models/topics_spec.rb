require 'spec_helper'

describe Topic do
  describe "validations" do
    it "requires a title" do
      topic = Topic.create
      topic.should_not be_valid
      topic.errors.should include :title
    end
  end

  describe '#for user' do
    let(:topic) { Topic.create!(:title => 'foo') }

    it 'includes public topics' do
      user = Fabricate.build(:user)
      Topic.for_user(user).should include(topic)
    end

    it 'includes topics in a group the user is in' do
      group = Group.create!(:name => 'group1')
      user = Fabricate.build(:user, :groups => [group])
      topic.update_attributes(:group => group)
      Topic.for_user(user).should include(topic)
    end

    it 'does not include topics in a group the user is not in' do
      user = Fabricate.build(:user)
      topic.update_attributes(:group => Group.create!(:name => 'group1'))
      Topic.for_user(user).should_not include(topic)
    end

    it 'does include topics not in a group for anonymous users' do
      Topic.for_user(nil).should include(topic)
    end

    it 'does not include topics in a group for anonymous users' do
      topic.update_attributes(:group => Group.create!(:name => 'group1'))
      Topic.for_user(nil).should_not include(topic)
    end
  end
end
