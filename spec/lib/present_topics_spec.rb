require 'spec_helper'

describe PresentTopics do
  let(:topic) { Fabricate(:topic) }

  it 'presents everything it needs to' do
    presented = PresentTopics.for([topic])
    presented.first[:description].should == topic.description
    presented.first[:slug].should == topic.slug
    presented.first[:title].should == topic.title
  end
end
