require 'spec_helper'

describe UserCodemarkAuthorizer do
  describe '#authorized?' do
    let(:author) { Fabricate(:user) }
    let(:user) { Fabricate(:user) }
    let(:group) { Group.create(:name => 'Foobar') }
    let(:codemark) { Fabricate(:codemark, :user => user, :group => group) }

    it 'is true for anonymous users to codemarks (public) groups' do
      codemark = Fabricate(:codemark, :user => author, :group => Group::DEFAULT)
      UserCodemarkAuthorizer.new(nil, codemark).should be_authorized
    end

    it 'is false for anonymous users to all other groups' do
      UserCodemarkAuthorizer.new(nil, codemark).should_not be_authorized
    end

    it 'is true for users with access to the group the codemark is in' do
      user.groups << codemark.group
      UserCodemarkAuthorizer.new(user, codemark).should be_authorized
    end

    it 'is true for users with access to the group the codemark is in' do
      user.groups = [Group::DEFAULT]
      UserCodemarkAuthorizer.new(user, codemark).should_not be_authorized
    end
  end
end
