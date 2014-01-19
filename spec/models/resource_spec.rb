require 'spec_helper'

describe Resource do
  describe 'Link' do
    it 'can exist' do
      link = Link.create!(:author => Fabricate(:user), :url => 'http://google.com')
      link.type.should == 'Link'
    end
  end

  describe 'Text' do
    it 'can exist' do
      text = Text.create!(:author => Fabricate(:user))
      text.type.should == 'Text'
    end
  end
end
