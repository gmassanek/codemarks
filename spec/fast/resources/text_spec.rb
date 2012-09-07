require 'fast_helper'
class TextRecord; end unless Object.const_defined?("TextRecord")

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
    it 'creates a new TextRecord' do
      attrs = {
        text: 'I have a brilliant idea',
        saver_id: 5
      }
      TextRecord.should_receive(:create!).with(attrs)
      Resource::Text.create!(saver_id: 4, text: 'Hey there')
    end
  end
end
