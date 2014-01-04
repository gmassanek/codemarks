require 'spec_helper'

describe UserCodemarkAuthorizer do
  describe '#authorized?' do
    let(:author) { Fabricate(:user) }
    let(:user) { Fabricate(:user) }
    let(:group) { Group.create(:name => 'Foobar') }

    it 'is true for anonymous users and codemarks in no group' do
      codemark = Fabricate(:codemark, :user => author, :group => nil)
      UserCodemarkAuthorizer.new(nil, codemark).should be_authorized
    end

    it 'is false for anonymous users to any group' do
      codemark = Fabricate(:codemark, :user => author, :group => group)
      UserCodemarkAuthorizer.new(nil, codemark).should_not be_authorized
    end

    it 'is true for users with access to the group the codemark is in' do
      user.groups = [group]
      codemark = Fabricate(:codemark, :user => author, :group => group)
      UserCodemarkAuthorizer.new(user, codemark).should be_authorized
    end

    it 'is false for users with access to the group the codemark is in' do
      user.groups = []
      codemark = Fabricate(:codemark, :user => author, :group => group)
      UserCodemarkAuthorizer.new(user, codemark).should_not be_authorized
    end
  end
end
