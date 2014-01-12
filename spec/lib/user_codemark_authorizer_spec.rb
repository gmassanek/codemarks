require 'spec_helper'

describe UserCodemarkAuthorizer do
  describe '#authorized?' do
    let(:author) { Fabricate(:user) }
    let(:user) { Fabricate(:user) }
    let(:group) { Group.create(:name => 'Foobar') }

    describe 'view' do
      it 'is true for anonymous users and codemarks in no group' do
        codemark = Fabricate(:codemark, :user => author, :group => nil)
        UserCodemarkAuthorizer.new(nil, codemark, :view).should be_authorized
      end

      it 'is false for anonymous users to any group' do
        codemark = Fabricate(:codemark, :user => author, :group => group)
        UserCodemarkAuthorizer.new(nil, codemark, :view).should_not be_authorized
      end

      it 'is true for users with access to the group the codemark is in' do
        user.groups = [group]
        codemark = Fabricate(:codemark, :user => author, :group => group)
        UserCodemarkAuthorizer.new(user, codemark, :view).should be_authorized
      end

      it 'is true for users in no group and the codemark in no group' do
        user.groups = []
        codemark = Fabricate(:codemark, :user => author, :group => nil)
        UserCodemarkAuthorizer.new(user, codemark, :view).should be_authorized
      end

      it 'is false for users with access to the group the codemark is in' do
        user.groups = []
        codemark = Fabricate(:codemark, :user => author, :group => group)
        UserCodemarkAuthorizer.new(user, codemark, :view).should_not be_authorized
      end
    end

    describe 'edit' do
      it 'is false for anonymous users and codemarks in no group' do
        codemark = Fabricate(:codemark, :user => author, :group => nil)
        UserCodemarkAuthorizer.new(nil, codemark, :edit).should_not be_authorized
      end

      it 'is false for anonymous user in no group and codemarks in no group' do
        user.groups = []
        codemark = Fabricate(:codemark, :user => author, :group => nil)
        UserCodemarkAuthorizer.new(user, codemark, :edit).should_not be_authorized
      end

      it 'is false for anonymous users to any group' do
        codemark = Fabricate(:codemark, :user => author, :group => group)
        UserCodemarkAuthorizer.new(nil, codemark, :edit).should_not be_authorized
      end

      it 'is true for users with access to the group the codemark is in' do
        user.groups = [group]
        codemark = Fabricate(:codemark, :user => author, :group => group)
        UserCodemarkAuthorizer.new(user, codemark, :edit).should be_authorized
      end
    end
  end
end
