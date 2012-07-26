require 'fast_helper'

describe Resource::Text do
  describe '#initialize' do
    it 'assigns attributes' do
      resource = Resource::Text.new(saver_id: 4, text: 'Hey there')
      resource.type.should == 'text'
      resource.saver_id.should == 4
      resource.text.should == 'Hey there'
    end
  end

  describe '#create!' do
    it 'creates a new TextResource' do
    end
  end
end
